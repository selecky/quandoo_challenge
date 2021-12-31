import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quandoo_challenge/blocs/pub_barrel.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';
import 'package:quandoo_challenge/repository/repository.dart';

import 'pubBloc_test.mocks.dart';

// Generate MockRepository using the Mockito package.
@GenerateMocks([Repository])
void main() {

  late MockRepository mockRepository;
  late PubBloc pubBloc;

  setUp((){
    mockRepository = MockRepository();
    pubBloc = PubBloc(repository: mockRepository);
  });

  group('PubBloc tests', () {

    blocTest(
      'emits [] when nothing is added',
      build: () {
        return pubBloc;
      },
      expect: () => [],
    );

    blocTest(
      'emits [StatePubsLoading, StatePubsLoadSuccess] when EventPubsLoad is added',
      build: () {

        // Use Mockito to return true when it calls the
        // mockRepository.hasInternet() method.
        when(mockRepository.hasInternet(any)).thenAnswer((_) async => true);

        // Use Mockito to return a successful response when it calls the
        // mockRepository.fetchPubs() method.
        when(mockRepository.fetchPubs(any)).thenAnswer((_) async => [
          Pub(
              name: 'name',
              location: Location(address: Address(
                  street: 'street',
                  number: 'number',
                  zipcode: 'zipcode',
                  city: 'city',
                  country: 'country',
                  district: 'district')),
              reviewScore: 'reviewScore',
              images: []
          ),
        ]);
        return pubBloc;
      },
      act: (bloc) => pubBloc.add(EventPubsLoad()),
      expect: () => [isA<StatePubsLoading>(), isA<StatePubsLoadSuccess>()],
    );

    blocTest(
      'emits [StatePubsLoading, StateNoInternet] when EventPubsLoad is added and no internet connection is available',
      build: () {

        // Use Mockito to return false when it calls the
        // mockRepository.hasInternet() method.
        when(mockRepository.hasInternet(any)).thenAnswer((_) async => false);

        return pubBloc;
      },
      act: (bloc) => pubBloc.add(EventPubsLoad()),
      expect: () => [isA<StatePubsLoading>(), isA<StateNoInternet>()],
    );

    blocTest(
      'emits [StatePubsLoading, StatePubsLoadFail] when EventPubsLoad is added and API call fails',
      build: () {

        // Use Mockito to return a successful response when it calls the
        // mockRepository.hasInternet() method.
        when(mockRepository.hasInternet(any)).thenAnswer((_) async => true);

        // Use Mockito to return an exception when it calls the
        // mockRepository.fetchPubs() method.
        when(mockRepository.fetchPubs(any)).thenThrow(Exception('API call failed'));
        return pubBloc;
      },
      act: (bloc) => pubBloc.add(EventPubsLoad()),
      expect: () => [isA<StatePubsLoading>(), isA<StatePubsLoadFail>()],
    );

  });

}
