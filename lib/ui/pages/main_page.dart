import 'package:flutter/material.dart';
import 'package:flutter_test_assignment/data/models/user_model.dart';

class MainPage extends StatelessWidget {
  final UserModel user;

  const MainPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('List page'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
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
                  child: DrawerButton(
                    icon: Icons.logout,
                    label: 'Log out',
                    onPressed: () {
                      //TODO: Impelement this one later.
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
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
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          child: Text('Profile', style: textTheme.titleSmall),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                foregroundImage: NetworkImage(user.pictureUrl),
                backgroundImage: const NetworkImage(
                  imagePlaceHolderUrl,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, style: textTheme.bodyLarge),

                  //FIXME: This may overflow if the email is long.
                  // Don't know how to fix this yet.
                  Text(user.email, style: textTheme.bodySmall),
                ],
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
