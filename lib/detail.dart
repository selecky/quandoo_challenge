import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/strings.dart';

import 'Pub.dart';
import 'blocks/bloc.dart';

class Detail extends StatefulWidget {
  const Detail({Key key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  PubBloc _bloc;
  Pub _selectedPub;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Strings.pubDetail),
        ),
        body: BlocBuilder<PubBloc, PubState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is StatePubsLoadSuccess) {

              _selectedPub = state.selectedPub;

              return Center(
                child: Text(_selectedPub?.name ?? Strings.noItemSelected),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
