import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/strings.dart';

import '../customWidgets/Pub.dart';
import '../blocs/pub_barrel.dart';

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(160), bottomRight: Radius.circular(160))),
          centerTitle: true,
          title: Text(Strings.pubDetail),
        ),
        body: Stack(
          children: [

//Background image
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                )),

            BlocBuilder<PubBloc, PubState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is StatePubsLoadSuccess) {

                  _selectedPub = state.selectedPub;

                  return Center(
                    child: Container(color: Colors.red,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedPub?.name ?? Strings.noItemSelected),
                          Text(_selectedPub?.location?.address?.street?? 'Hovno'),
                          Text(_selectedPub?.reviewScore.toString()?? 'no score'),
                          Text(_selectedPub?.images?.length.toString()?? 'no images'),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ));
  }
}
