import 'package:equatable/equatable.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';

abstract class PubState {
  const PubState();
}

class StatePubsLoading extends PubState {}

class StatePubsLoadFail extends PubState {}

class StatePubsLoadSuccess extends PubState {
  final List<Pub> pubList;
  final Pub? selectedPub;
  StatePubsLoadSuccess(this.pubList, this.selectedPub);
}

class StateNoInternet extends PubState {}
