import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:quandoo_challenge/repository/repository.dart';

class Pub extends Equatable {
  final String name;
  final Location location;
  final String reviewScore;
  final List<PhotoUrl> images;

  const Pub({
    @required this.name,
    @required this.location,
    @required this.reviewScore,
    @required this.images,
  });

  // factory Pub.fromJson(Map<String, dynamic> pubJson) {
  //   return Pub(
  //     name: pubJson['name'],
  //     // location: pubJson['location'],
  //     reviewScore: pubJson['reviewScore'],
  //     images: pubJson['images'],
  //   );
  // }

  @override
  List<Object> get props => [
    name,
    // location,
    reviewScore,
    images
  ];
}
