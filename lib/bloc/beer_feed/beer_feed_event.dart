part of 'beer_feed_bloc.dart';

@immutable
abstract class BeerFeedEvent extends Equatable {
  const BeerFeedEvent();
}

class BeerFeedFetch extends BeerFeedEvent {
  final int page;
  final int perPage;

  const BeerFeedFetch(this.page, {this.perPage = 50});

  @override
  List<Object> get props => [];
}
