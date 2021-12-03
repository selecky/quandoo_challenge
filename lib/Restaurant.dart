import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String name;
  final String address;

  const Restaurant({
    required this.name,
    required this.address,
  });

  factory Restaurant.fromRestaurant(Restaurant restaurant) {
    return Restaurant(name: restaurant.name, address: restaurant.address);
  }

  @override
  List<Object> get props => [name, address];
}
