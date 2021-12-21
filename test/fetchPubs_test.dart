import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';
import 'package:quandoo_challenge/repository/repository.dart';
import 'package:quandoo_challenge/strings.dart';

import 'fetchPubs_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {

  final repository = Repository();

  group('fetchPubs', () {

    test('returns a Restaurant if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
          .get(Uri.parse(Strings.quandooAPIUrl)))
          .thenAnswer((_) async =>
          http.Response(Strings.sampleResponse, 200));

      expect(await repository.fetchPubs(client), isA<List<Pub>>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client
          .get(Uri.parse(Strings.quandooAPIUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(repository.fetchPubs(client), throwsException);
    });
  });
}