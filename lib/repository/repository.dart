import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:quandoo_challenge/customWidgets/Pub.dart';

import '../strings.dart';

class Repository {

  Future<bool> hasInternet() async {

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Mobile data detected & internet connection confirmed.
        return true;
      } else {
        // Mobile data detected but no internet connection found.
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      if (await DataConnectionChecker().hasConnection) {
        // Wifi detected & internet connection confirmed.
        return true;
      } else {
        // Wifi detected but no internet connection found.
        return false;
      }
    } else if (await DataConnectionChecker().hasConnection) {
      // I am connected to internet with other means - e.g. ethernet.
      return true;
    } else {
      // Neither mobile data, WIFI, or other connection detected, no internet connection found.
      return false;
    }
  }



  Future<List<Pub>> fetchPubs(http.Client client) async {

    final response = await client.get(Uri.parse(Strings.quandooAPIUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List<Pub> loadedPubs = [];

      var responseBodyMap =
          Map<String, dynamic>.from(jsonDecode(response.body));

      var pubMapList =
          List<Map<String, dynamic>>.from(responseBodyMap["merchants"]);

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

class Address{
  String street;
  String number;
  String zipcode;
  String city;
  String country;
  String district;

  Address({
    this.street,
    this.number,
    this.zipcode,
    this.city,
    this.country,
    this.district,
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

class Location{
  Address address;

  Location({
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> locationJson) {
    return Location(
      address: Address.fromJson(locationJson['address'])
    );
  }

}

class PhotoUrl{
  String url;

  PhotoUrl({
    this.url,
  });

  factory PhotoUrl.fromJson(Map<String, dynamic> photoUrlJson) {
    return PhotoUrl(
      url: photoUrlJson['url'],
    );
  }

}
