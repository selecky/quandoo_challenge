import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:quandoo_challenge/customWidgets/Pub.dart';
import 'package:quandoo_challenge/repository/repository.dart';

import 'pub_barrel.dart';

class PubBloc extends Bloc<PubEvent, PubState> {
  List<Pub> _pubs = [];
  Pub _selected;
  final Repository repository;

  PubBloc({@required this.repository, PubState initialState});

  PubState get initialState => StatePubsLoading();

  @override
  Stream<PubState> mapEventToState(
    PubEvent event,
  ) async* {
    if (event is EventPubSelect) {
      _selected = event.selected;

      if(state is StatePubsLoadSuccess){
        _pubs = List.from((state as StatePubsLoadSuccess).pubList);
      }

      yield StatePubsLoadSuccess(_pubs, _selected);
    }
    if (event is EventPubsLoad) {
      yield StatePubsLoading(); // to show progress indicator while waiting for the data

      //check for internet connection
      bool hasInternet = await repository.hasInternet();
      if (!hasInternet) {
             yield StateNoInternet();
        return;
      }

      _pubs = await repository.fetchPubs(http.Client());
      yield StatePubsLoadSuccess(_pubs, _selected);
    }
  }

}
