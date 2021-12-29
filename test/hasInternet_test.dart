
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quandoo_challenge/repository/repository.dart';

import 'hasInternet_test.mocks.dart';


// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([Connectivity, InternetConnectionChecker])
void main() {

  late Connectivity connectivity;
  late InternetConnectionChecker internetConnectionChecker;
  late Repository repository;
  
  setUp((){
    connectivity = MockConnectivity();
    internetConnectionChecker = MockInternetConnectionChecker();
    repository = Repository();
  });

  group('check for internet connection', (){

    test('check for mobile having a connection', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.mobile);
      when(internetConnectionChecker.hasConnection).thenAnswer((_) async => true);

      expect(await repository.hasInternet(connectivity), true);
    });

  });
}