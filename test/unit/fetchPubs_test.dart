import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';
import 'package:quandoo_challenge/repository/repository.dart';
import 'package:quandoo_challenge/strings.dart';

import 'fetchPubs_test.mocks.dart';


// Generate a MockClient using the Mockito package.
@GenerateMocks([http.Client])
void main() {

  final repository = Repository();
  late http.Client mockClient;

  setUp((){
    mockClient = MockClient();
  });

  group('fetchPubs', () {

    test('returns a Restaurant if the http call completes successfully', () async {
      // Use MockClient to return a successful response.
      when(mockClient
          .get(Uri.parse(Strings.quandooAPIUrl)))
          .thenAnswer((_) async =>
          http.Response(Strings.sampleResponse, 200));
      expect(await repository.fetchPubs(mockClient), isA<List<Pub>>());
    });

    test('throws an exception if the http call completes with an error', () {
      // Use MockClient to return an 'Not Found' response.
      when(mockClient
          .get(Uri.parse(Strings.quandooAPIUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      expect(repository.fetchPubs(mockClient), throwsException);
    });
  });
}