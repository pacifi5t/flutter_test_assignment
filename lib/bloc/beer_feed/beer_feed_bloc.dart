import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_assignment/data/apis/apis.dart';
import 'package:flutter_test_assignment/data/models/beer_model.dart';

part 'beer_feed_event.dart';
part 'beer_feed_state.dart';

class BeerFeedBloc extends Bloc<BeerFeedEvent, BeerFeedState> {
  final PexelsApi pexelsApi;

  BeerFeedBloc(super.initialState, this.pexelsApi) {
    on<BeerFeedFetch>((event, emit) async {
      emit(BeerFeedLoadInProgress());

      try {
        final beerModels = await pexelsApi.fetchFeed(event.page, event.perPage);
        emit(BeerFeedLoaded(GroupedBeerModelsByAlphabet.ascending(beerModels)));
      } on ServerErrorException catch (exception) {
        debugPrint(exception.toString());
        emit(const BeerFeedLoadError("Server error, please try again"));
      } catch (exception) {
        debugPrint(exception.toString());
        emit(const BeerFeedLoadError("Unknown error, please try again"));
      }
    });
  }
}

class GroupedBeerModelsByAlphabet {
  final List<String> firstLetters;
  final Map<String, List<BeerModel>> firstLetterToGroupMap;

  GroupedBeerModelsByAlphabet(this.firstLetters, this.firstLetterToGroupMap);

  factory GroupedBeerModelsByAlphabet.ascending(List<BeerModel> beerModels) {
    final List<String> firstLetters = [];
    final Map<String, List<BeerModel>> groupedBeerModels = {};

    final sortedBeerModels = [...beerModels];
    sortedBeerModels.sort((a, b) => a.name.compareTo(b.name));

    for (final model in sortedBeerModels) {
      final firstLetter = model.name[0].toUpperCase();
      firstLetters.add(firstLetter);
      groupedBeerModels.update(
        firstLetter,
        (old) => [...old, model],
        ifAbsent: () => [model],
      );
    }

    firstLetters.sort();
    return GroupedBeerModelsByAlphabet(
      firstLetters.toSet().toList(),
      groupedBeerModels,
    );
  }
}
