import 'package:auto_size_text/auto_size_text.dart';
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

class _DetailState extends State<Detail> with TickerProviderStateMixin {
  PubBloc _bloc;
  Pub _selectedPub;
  TabController _tabController;
  List<String> pubPhotosList = [];
  AnimationController _controllerReview;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);

    _controllerReview = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

  }

  @override
  void dispose() {
    _tabController?.dispose();
    _controllerReview.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(160),
                  bottomRight: Radius.circular(160))),
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

                  _controllerReview.reset();
                  _controllerReview.forward();

                  bool isLandscape = MediaQuery.of(context).size.width >
                      MediaQuery.of(context).size.height;

                  if (_selectedPub != null) {
                    pubPhotosList =
                        _selectedPub.images?.map((e) => e.url)?.toList();

                    _tabController = TabController(
                        length: _selectedPub.images.length, vsync: this);
                  }

                  return _selectedPub != null
                      ? Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: pubPhotosList.isEmpty
                                  //display only icon when no photos for restaurant available
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      color: Theme.of(context).primaryColor,
                                      child: Icon(
                                        Icons.deck_rounded,
                                        size: 200,
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        //Support containers for immediate caching of all restaurant images (invisible)
                                        // - this helps to prevent bad UX when scrolling the tabBarView
                                        Column(
                                          children: pubPhotosList
                                              .map((String photoUrl) {
                                            return Container(
                                                width: 0,
                                                height: 0,
                                                child: Image.network(
                                                  photoUrl,
                                                  cacheWidth: 500,
                                                ));
                                          }).toList(),
                                        ),
                                        TabBarView(
                                          key: ObjectKey(pubPhotosList[0]),
                                          //without key the TabBarView index does not reset on new restaurant click
                                          controller: _tabController,
                                          children:
                                              pubPhotosList.map((String url) {
                                            return FittedBox(
                                                fit: BoxFit.cover,
                                                child: Image.network(
                                                  url,
                                                  cacheWidth: 500,
                                                ));
                                          }).toList(),
                                        ),
//Name field
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            height: 200,
                                            width: isLandscape
                                                ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    8
                                                : MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            padding:
                                                const EdgeInsets.only(top: 36),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(1),
                                                Colors.black.withOpacity(0),
                                              ],
                                            )),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 64,
                                                    right: 64,
                                                    top: 8),
                                                child:
//Name
                                                    AutoSizeText(
                                                        _selectedPub.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline1),
                                              ),
                                            ),
                                          ),
                                        ),

//Top curved border
                                        Positioned(
                                          bottom: -1,
                                          child: Container(
                                            width: isLandscape
                                                ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    8
                                                : MediaQuery.of(context)
                                                    .size
                                                    .width,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              // Strings.myColorGrey,
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(150),
                                                  topLeft:
                                                      Radius.circular(150)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black38,
                                                    offset: Offset(4, 4),
                                                    blurRadius: 16.0,
                                                    spreadRadius: 4.0)
                                              ],
                                            ),
                                          ),
                                        ),

//review - animated
                                        Positioned(
                                            top: 120,
                                            right: 32,
                                            child: AnimatedBuilder(
                                              animation: _controllerReview,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(32),
                                                  color: Colors.black26
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8, top: 4),
                                                      child: Text(_selectedPub.reviewScore + '/6', style: Theme.of(context).textTheme.headline1,),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              builder: (context, child) {
                                                return Transform(
                                                    child: child,
                                                    transform: Matrix4.translationValues(
                                                        Tween<double>(
                                                                begin: 68,
                                                                end: 0)
                                                            .animate(CurvedAnimation(
                                                                parent:
                                                                    _controllerReview,
                                                                curve: Interval(
                                                                    0, 1,
                                                                    curve: Curves
                                                                        .elasticOut)))
                                                            .value,
                                                        0,
                                                        0));
                                              },
                                            )),
                                      ],
                                    ),
                            ),
//address
                            Container(
                              padding:
                                  EdgeInsets.only(left: 32, right: 32, top: 16),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                              color: Theme.of(context).canvasColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.address,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  Container(
                                    height: 8,
                                  ), //spacer
                                  Text(
                                      _selectedPub.location.address.street +
                                          ' ' +
                                          _selectedPub.location.address.number,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                  Text(_selectedPub.location.address.district,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                  Text(
                                      _selectedPub.location.address.zipcode +
                                          ' ' +
                                          _selectedPub.location.address.city,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                  Text(_selectedPub.location.address.country,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                ],
                              ),
                            )
                          ],
                        )

//no item selected
                      : Center(
                          child: Container(
                            color: Colors.red,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedPub?.name ??
                                    Strings.noItemSelected),
                                Text(_selectedPub?.location?.address?.street ??
                                    'Hovno'),
                                Text(_selectedPub?.reviewScore.toString() ??
                                    'no score'),
                                Text(_selectedPub?.images?.length.toString() ??
                                    'no images'),
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
