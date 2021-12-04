import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Pub extends Equatable {
  final String name;
  final String address;

  const Pub({
    @required this.name,
    @required this.address,
  });

  factory Pub.fromJson(Map<String, dynamic> json) {
    return Pub(
      name: json['name'],
      address: json['address'],
    );
  }

  @override
  List<Object> get props => [name, address];
}
