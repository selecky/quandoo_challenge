import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/repository/repository.dart';
import 'package:quandoo_challenge/strings.dart';

import '../blocs/pub_barrel.dart';
import '../customWidgets/Pub.dart';
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
  bool _isTablet;
  Repository _repository;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);
    _repository = _bloc.repository;
  }

  @override
  Widget build(BuildContext context) {

    _isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
//Background animation
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FlareActor(
                'assets/animations/eating.flr',
                animation: 'move',
                fit: BoxFit.fill,
              ),
            ),

            BlocBuilder<PubBloc, PubState>(
                bloc: _bloc,
                builder: (context, state) {
                  //if there is no internet connection prompt the user to connect
                  if (state is StateNoInternet) {
                    return Center(
                        child: noInternetLayout(_bloc, _repository, context));
                  } else if (state is StatePubsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is StatePubsLoadSuccess) {
                    _pubList = state.pubList;
                    _selectedPub = state.selectedPub;

                    return RawScrollbar(
                      radius: Radius.circular(16),
                      thumbColor: Theme.of(context).primaryColor,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(160),
                                    bottomRight: Radius.circular(160))),
                            centerTitle: true,
                            pinned: false,
                            floating: true,
                            expandedHeight: 64.0,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Padding(
                                padding: EdgeInsets.only(right: 48),
                                //row used to center title
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      Strings.pubList,
                                      style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //container to add some space at the top of the gridView
                          SliverToBoxAdapter(
                              child: Container(
                                  height: 16,
                                 )),
                          SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _isTablet ? 2 : 1,
                                childAspectRatio: 3 / 1.82,
                                // mainAxisSpacing: 8.0,
                                // crossAxisSpacing: 8.0,
                              ),
                              delegate: SliverChildBuilderDelegate (
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: MyPubCard(
                                        pub: _pubList[index],
                                        isHighlighted: _selectedPub == _pubList[index],
                                        onTap: () async {
                                          _bloc.add(EventPubSelect(_pubList[index]));
                                          if (!_isTablet) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Detail()));
                                          }
                                        },
                                      ),
                                    );
                                  },
                                childCount: _pubList.length,
                              ) ),
                        ],
                      ),
                    );

//StatePubsLoadFail - API all failed
                  } else {
                    return Center(
                        child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(32)),
                      child: Text(
                        Strings.errorLoadingPubs,
                        style: _isTablet
                            ? Theme.of(context).textTheme.headline2
                            : Theme.of(context).textTheme.bodyText1,
                      ),
                    ));
                  }
                }),
          ],
        ));
  }
}

//Layout displayed when no internet connection is found
Widget noInternetLayout(
    Bloc bloc, Repository repository, BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    Strings.noInternetShort,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
              //spacer
              Container(
                height: 8,
              ),
              Text(
                Strings.noInternetLong,
                style: Theme.of(context).textTheme.bodyText1,
              ),
//try again button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                    onTap: () async {
                      //check for internet connection
                      bool hasInternet = await repository.hasInternet();
                      if (!hasInternet) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(Strings.noInternetLong)));
                        return;
                      } else {
                        //if there is internet, make the API call
                        bloc.add(EventPubsLoad());
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          Strings.tryAgain.toUpperCase(),
                          style: Theme.of(context).textTheme.headline5,
                        ))),
              )
            ],
          )),
    ),
  );
}
