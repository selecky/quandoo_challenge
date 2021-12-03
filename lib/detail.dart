import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/strings.dart';

import 'blocks/bloc.dart';

class Detail extends StatefulWidget {
  const Detail({Key key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  PubBloc _bloc;

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
          builder: (context, state) {
            if (state is StatePubsLoadSuccess) {
              return Center(
                child: Text(state.selectedPub?.name ?? "No item selected"),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
