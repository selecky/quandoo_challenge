
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quandoo_challenge/customWidgets/Pub.dart';
import 'package:quandoo_challenge/repository/repository.dart';

import 'pub_barrel.dart';

class PubBloc extends Bloc<PubEvent, PubState> {
  List<Pub> _pubs = [];
  Pub? _selected;
  final Repository repository;

  PubBloc({required this.repository}) : super(StatePubsLoading()) {

    on<EventPubsLoad>(
      (event, emit) async {
        emit(StatePubsLoading()); // to show progress indicator while waiting for the data)
        //check for internet connection
        bool hasInternet = await repository.hasInternet();
        if (!hasInternet) {
          emit(StateNoInternet());
          return;
        }
        try{
          _pubs = await repository.fetchPubs(http.Client());
          emit(StatePubsLoadSuccess(_pubs, _selected));
        } catch  (e){
          print(e);
          emit(StatePubsLoadFail());
        }

      },
    );

    on<EventPubSelect>(
      (event, emit) {
        _selected = event.selected;
        if (state is StatePubsLoadSuccess) {
          _pubs = (state as StatePubsLoadSuccess).pubList;
        }
        emit(StatePubsLoadSuccess(_pubs, _selected));
      },
    );
  }
}
