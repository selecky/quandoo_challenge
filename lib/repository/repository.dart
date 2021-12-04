import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quandoo_challenge/customWidgets/Pub.dart';

import '../strings.dart';

class Repository {
  Future<List<Pub>> fetchPubs() async {
    final response = await http.get(Uri.parse(Strings.quandooUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      List<Pub> loadedPubs = [];
      var responseBodyMap =
          Map<String, dynamic>.from(jsonDecode(response.body));
      var resultMapList =
          List<Map<String, dynamic>>.from(responseBodyMap["merchants"]);

      loadedPubs = resultMapList.map((Map<String, dynamic> pubMap) {
        return Pub(name: pubMap["name"], address: pubMap["address"]);
      }).toList();

      return loadedPubs;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
