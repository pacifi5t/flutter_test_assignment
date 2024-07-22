part of 'beer_feed_bloc.dart';

@immutable
abstract class BeerFeedState extends Equatable {
  const BeerFeedState();
}

final class BeerFeedInitial extends BeerFeedState {
  @override
  List<Object> get props => [];
}

final class BeerFeedLoadInProgress extends BeerFeedState {
  @override
  List<Object> get props => [];
}

final class BeerFeedLoadError extends BeerFeedState {
  final String errorMessage;

  const BeerFeedLoadError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class BeerFeedLoaded extends BeerFeedState {
  final GroupedBeerModelsByAlphabet groupedBeerModels;

  const BeerFeedLoaded(this.groupedBeerModels);

  @override
  List<Object> get props => [groupedBeerModels];
}
