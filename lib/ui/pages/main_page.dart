import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_assignment/bloc/beer_feed/beer_feed_bloc.dart';
import 'package:flutter_test_assignment/data/apis/apis.dart';
import 'package:flutter_test_assignment/data/models/models.dart';
import 'package:flutter_test_assignment/ui/pages/pages.dart';

class MainPage extends StatelessWidget {
  final UserModel user;

  const MainPage({super.key, required this.user});

  void showLogoutDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    Scaffold.of(context).closeDrawer();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: Text(
            'Are you sure you want to logout?',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.secondary,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text(
                'Log out',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void refreshBeerFeed(BuildContext context) {
    BlocProvider.of<BeerFeedBloc>(context).add(
      BeerFeedFetch(Random().nextInt(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeerFeedBloc(
        BeerFeedInitial(),
        PexelsApi.withDefaultOptions(),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Colors.transparent,
          title: const Text('List page'),
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu),
              );
            },
          ),
          actions: [
            BlocBuilder<BeerFeedBloc, BeerFeedState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: state is! BeerFeedLoadInProgress
                      ? () => refreshBeerFeed(context)
                      : null,
                  icon: const Icon(Icons.refresh),
                );
              },
            )
          ],
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileCard(user: user),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Builder(builder: (context) {
                      return DrawerButton(
                        icon: Icons.logout,
                        label: 'Log out',
                        onPressed: () => showLogoutDialog(context),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<BeerFeedBloc, BeerFeedState>(
          builder: (context, state) {
            if (state is BeerFeedInitial) {
              BlocProvider.of<BeerFeedBloc>(context).add(
                const BeerFeedFetch(1),
              );
            } else if (state is BeerFeedLoadInProgress) {
              return const BeerFeedViewLoadInProgress();
            } else if (state is BeerFeedLoadError) {
              return BeerFeedViewLoadError(state.errorMessage);
            } else if (state is BeerFeedLoaded) {
              return BeerFeedViewLoaded(state.groupedBeerModels);
            }
            return const BeerFeedViewEmpty();
          },
        ),
      ),
    );
  }
}

class BeerFeedViewEmpty extends StatelessWidget {
  const BeerFeedViewEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'No items',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}

class BeerFeedViewLoadInProgress extends StatelessWidget {
  const BeerFeedViewLoadInProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 64,
        height: 64,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

class BeerFeedViewLoadError extends StatelessWidget {
  final String errorMessage;

  const BeerFeedViewLoadError(this.errorMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        errorMessage,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}

class BeerFeedViewLoaded extends StatelessWidget {
  final GroupedBeerModelsByAlphabet groupedBeerModels;

  const BeerFeedViewLoaded(this.groupedBeerModels, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<BeerCardGroup> groups = [];

    for (final letter in groupedBeerModels.firstLetters) {
      final cards = groupedBeerModels.firstLetterToGroupMap[letter]!.map(
        (model) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: BeerCard(beer: model),
        ),
      );
      groups.add(BeerCardGroup(letter: letter, children: cards.toList()));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Scrollbar(
        thickness: 3,
        radius: const Radius.circular(21),
        child: ListView(
          // For some reason, iOS renders scrollbar a bit differently
          padding: EdgeInsets.only(right: Platform.isIOS ? 9 : 6),
          children: groups,
        ),
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  final UserModel user;

  static const imagePlaceHolderUrl =
      'https://pathwayactivities.co.uk/wp-content/uploads/2016/04/'
      'Profile_avatar_placeholder_large-circle-300x300.png';

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Text('Profile', style: textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                foregroundImage: NetworkImage(user.pictureUrl),
                backgroundImage: const NetworkImage(imagePlaceHolderUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.username, style: textTheme.bodyLarge),
                    Text(
                      user.email,
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class DrawerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const DrawerButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        label: Text(label),
        icon: Icon(icon),
      ),
    );
  }
}

class BeerCardGroup extends StatelessWidget {
  final String letter;
  final List<Widget> children;

  const BeerCardGroup({
    super.key,
    required this.letter,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SizedBox(
            width: 11,
            child: Center(
              child: Text(
                letter,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(children: children),
        ),
      ],
    );
  }
}

class BeerCard extends StatelessWidget {
  final BeerModel beer;

  const BeerCard({super.key, required this.beer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4, right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                fit: BoxFit.cover,
                width: 56,
                height: 56,
                image: NetworkImage(beer.pictureUrl),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  beer.name,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  beer.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
