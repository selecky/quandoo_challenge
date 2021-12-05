import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/strings.dart';

import '../customWidgets/Pub.dart';
import '../blocs/pub_barrel.dart';
import '../customWidgets/myPubCard.dart';
import 'detail.dart';

class Master extends StatefulWidget {
  const Master({Key key}) : super(key: key);

  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  PubBloc _bloc;
  List<Pub> _pubList;
  Pub _selectedPub;
  bool isLandscape;
  bool isTablet;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);
    _bloc.add(EventPubsLoad());
  }


  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
    isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(160), bottomRight: Radius.circular(160))),
          centerTitle: true,
          title: Text(Strings.pubList),
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
              if (state is StatePubsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is StatePubsLoadSuccess) {

                _pubList = state.pubList;
                _selectedPub = state.selectedPub;

                return GridView.builder(
                    itemCount: _pubList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet? 2 : 1,
                        childAspectRatio: 3 / 1.9
                    ),
                    padding: const EdgeInsets.only(
                        top: 96, bottom: 64, left: 16, right: 16),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MyPubCard(
                          pub: _pubList[index],
                          isHighlighted: _selectedPub == _pubList[index],
                          onTap: () {
                            _bloc.add(EventPubSelect(_pubList[index]));
                            if (!isLandscape) {
                              Navigator.push(context,  MaterialPageRoute(builder: (context) => Detail()));
                            }
                          },
                        ),
                      );
                    });

                //StatePubsLoadFail
              } else {
                return Center(child: Text(Strings.errorLoadingPubs));
              }

            }),
          ],
        ));
  }
}
