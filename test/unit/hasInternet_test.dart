
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quandoo_challenge/repository/repository.dart';

import 'hasInternet_test.mocks.dart';


// Generate MockInternetConnectionChecker using the Mockito package.
@GenerateMocks([InternetConnectionChecker])
void main() {

  late InternetConnectionChecker mockChecker;
  late Repository repository;
  
  setUp((){
    mockChecker = MockInternetConnectionChecker();
    repository = Repository();
  });

  group('check for internet connection', (){

    test('connection available', () async{
      when(mockChecker.hasConnection).thenAnswer((_) async => true);
      expect(await repository.hasInternet(mockChecker), true);
    });

    test('no connection', () async{
      when(mockChecker.hasConnection).thenAnswer((_) async => false);
      expect(await repository.hasInternet(mockChecker), false);
    });

  });
}