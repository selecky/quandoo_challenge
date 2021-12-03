import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Pub extends Equatable {
  final String name;
  final String address;

  const Pub({
    @required this.name,
    @required this.address,
  });

  factory Pub.fromPub(Pub pub) {
    return Pub(name: pub.name, address: pub.address);
  }

  @override
  List<Object> get props => [name, address];
}
