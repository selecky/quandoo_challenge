import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/Pub.dart';

import 'bloc.dart';

class PubBloc extends Bloc<PubEvent, PubState> {
  List<Pub> _pubs = [];
  Pub _selected;

  PubBloc(PubState initialState) : super(initialState);

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
      Pub pub0 = Pub(name: 'Sabor Latino-0', address: 'za rohem 123-0');
      Pub pub1 = Pub(name: 'Sabor Latino-1', address: 'za rohem 123-1');
      Pub pub2 = Pub(name: 'Sabor Latino-2', address: 'za rohem 123-2');
      Pub pub3 = Pub(name: 'Sabor Latino-3', address: 'za rohem 123-3');
      _pubs = [pub0, pub1, pub2, pub3];
      yield StatePubsLoadSuccess(_pubs, _selected);
    }
  }

}
