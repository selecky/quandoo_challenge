import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';

import '../strings.dart';

class Repository {

  //checking if the internet connection is available
  Future<bool> hasInternet(InternetConnectionChecker checker) async {
    if (await checker.hasConnection) {
      return true;
    } else {
      return false;
    }
  }

  //making API call to fetch restaurants data and converting them into a list of Dart objects
  Future<List<Pub>> fetchPubs(http.Client client) async {
    final response = await client.get(Uri.parse(Strings.quandooAPIUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List<Pub> loadedPubs = [];

      var responseBodyMap = Map<String, dynamic>.from(jsonDecode(response.body));

      var pubMapList = List<Map<String, dynamic>>.from(responseBodyMap["merchants"]);

      loadedPubs = pubMapList.map((Map<String, dynamic> pubMap) {
        var list = pubMap['images'] as List;
        // print(list.runtimeType); //returns List<dynamic>
        List<PhotoUrl> photoUrlList = list.map((i) => PhotoUrl.fromJson(i)).toList();

        return Pub(
          name: pubMap["name"],
          location: Location.fromJson(pubMap['location']),
          reviewScore: pubMap["reviewScore"],
          images: photoUrlList,
        );
      }).toList();

      return loadedPubs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class Address {
  String street;
  String number;
  String zipcode;
  String city;
  String country;
  String district;

  Address({
    required this.street,
    required this.number,
    required this.zipcode,
    required this.city,
    required this.country,
    required this.district,
  });

  factory Address.fromJson(Map<String, dynamic> addressJson) {
    return Address(
      street: addressJson['street'],
      number: addressJson['number'],
      zipcode: addressJson['zipcode'],
      city: addressJson['city'],
      country: addressJson['country'],
      district: addressJson['district'],
    );
  }
}

class Location {
  Address address;

  Location({
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> locationJson) {
    return Location(address: Address.fromJson(locationJson['address']));
  }
}

class PhotoUrl {
  String url;

  PhotoUrl({
    required this.url,
  });

  factory PhotoUrl.fromJson(Map<String, dynamic> photoUrlJson) {
    return PhotoUrl(
      url: photoUrlJson['url'],
    );
  }
}
