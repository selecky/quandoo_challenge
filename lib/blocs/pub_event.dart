import 'package:equatable/equatable.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';

abstract class PubEvent extends Equatable {
  const PubEvent();
}

class EventPubsLoad extends PubEvent {
  @override
  List<Object> get props => [];
}

class EventPubSelect extends PubEvent {
  final Pub selected;

  EventPubSelect(this.selected);

  @override
  List<Object> get props => [selected];
}
