import 'package:equatable/equatable.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';

abstract class PubState extends Equatable {
  const PubState();
}

class StatePubsLoading extends PubState {
  @override
  List<Object> get props => [];
}

class StatePubsLoadFail extends PubState {
  @override
  List<Object> get props => [];
}

class StatePubsLoadSuccess extends PubState {
  final List<Pub> pubList;
  final Pub selectedPub;

  StatePubsLoadSuccess(this.pubList, this.selectedPub);

  @override
  List<Object> get props => [selectedPub, ...pubList];
}
