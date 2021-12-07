import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/repository/repository.dart';
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
  Repository repository;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);
    _bloc.add(EventPubsLoad());
    repository = _bloc.repository;
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
                child: FlareActor(
                  'assets/animations/eating.flr',
                  animation: 'move',
                  fit: BoxFit.fill,),),

            BlocBuilder<PubBloc, PubState>(
              bloc: _bloc,
                builder: (context, state) {

                //if there is no internet connection
                  if (state is StateNoInternet) {
                    return Center(child: noInternetLayout(_bloc, repository, context));
                  }

              else if (state is StatePubsLoading) {
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
                          onTap: () async{
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

Widget noInternetLayout(Bloc bloc, Repository repository, BuildContext context) {
  return                     Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AutoSizeText(
                  Strings.noInternet
                  // style: Theme.of(context).textTheme.button,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                    onTap: () async{

                      //check for internet connection
                      bool hasInternet = await repository.hasInternet();
                      if (!hasInternet) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.noInternet)));
                        return;
                      } else {
                        bloc.add(EventPubsLoad());
                      }

                    },
                    child: Text(Strings.tryAgain)
                ),
              )
            ],
          )),
    ),
  );
}
