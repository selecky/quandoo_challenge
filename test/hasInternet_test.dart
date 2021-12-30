
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quandoo_challenge/repository/repository.dart';

import 'hasInternet_test.mocks.dart';


// Generate MockConnectivity and MockInternetConnectionChecker using the Mockito package.
@GenerateMocks([Connectivity, InternetConnectionChecker])
void main() {

  late Connectivity connectivity;
  late InternetConnectionChecker checker;
  late Repository repository;
  
  setUp((){
    connectivity = MockConnectivity();
    checker = MockInternetConnectionChecker();
    repository = Repository();
  });

  group('check for internet connection under various circumstances', (){

    test('check for mobile having a connection', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.mobile);
      when(checker.hasConnection).thenAnswer((_) async => true);
      expect(await repository.hasInternet(connectivity, checker), true);
    });

    test('check for mobile without a connection', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.mobile);
      when(checker.hasConnection).thenAnswer((_) async => false);
      expect(await repository.hasInternet(connectivity, checker), false);
    });

    test('check for wifi having a connection', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);
      when(checker.hasConnection).thenAnswer((_) async => true);
      expect(await repository.hasInternet(connectivity, checker), true);
    });

    test('check for wifi without a connection', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);
      when(checker.hasConnection).thenAnswer((_) async => false);
      expect(await repository.hasInternet(connectivity, checker), false);
    });

    test('check for ethernet having a connection', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.ethernet);
      when(checker.hasConnection).thenAnswer((_) async => true);
      expect(await repository.hasInternet(connectivity, checker), true);
    });

    test('check for ethernet without a connection', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.ethernet);
      when(checker.hasConnection).thenAnswer((_) async => false);
      expect(await repository.hasInternet(connectivity, checker), false);
    });

    test('check for ConnectivityResult.none', () async{
      when(connectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.none);
      when(checker.hasConnection).thenAnswer((_) async => false);
      expect(await repository.hasInternet(connectivity, checker), false);
    });

  });
}