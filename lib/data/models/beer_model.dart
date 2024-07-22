import 'package:equatable/equatable.dart';

class BeerModel extends Equatable {
  final String name;
  final String description;
  final String pictureUrl;

  const BeerModel(this.name, this.description, this.pictureUrl);

  @override
  List<Object?> get props => [name, description, pictureUrl];
}
