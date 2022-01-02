import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/strings.dart';

import '../customWidgets/Pub.dart';
import '../blocs/pub_barrel.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key,}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with TickerProviderStateMixin {
  late PubBloc _bloc;
  Pub? _selectedPub;
  TabController? _tabController;
  late List<String> _pubPhotosList;
  late AnimationController _controllerIntro;
  bool _isTablet = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);

    _controllerIntro = AnimationController(duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _controllerIntro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Scaffold(
        body: Stack(
      children: [
//Background animation image
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FlareActor(
            'assets/animations/eating.flr',
            animation:
            // 'move',
            'static',
            fit: BoxFit.fill,
          ),
        ),

        BlocBuilder<PubBloc, PubState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is StatePubsLoadSuccess) {
              _selectedPub = state.selectedPub;

              //restart review animation on each new restaurant click
              _controllerIntro.reset();
              _controllerIntro.forward();

              //convert List<PhotoUrl> to List<String>
              _pubPhotosList = _selectedPub?.images?.map((e) => e.url)?.toList() ?? [];

              _tabController = TabController(length: _selectedPub?.images.length ?? 1, vsync: this);

              return _selectedPub != null
                  ? Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Stack(
                            children: [
//photos
                              _pubPhotosList.isNotEmpty
                                  ? TabBarView(
                                      //without key the TabBarView index does not reset on new restaurant click
                                      key: ObjectKey(_pubPhotosList[0]),

                                      controller: _tabController,
                                      children: _pubPhotosList.map((String url) {
                                        return FittedBox(
                                            fit: BoxFit.cover,
                                            child: Image.network(
                                              url,
                                              cacheWidth: 500,
                                            ));
                                      }).toList(),
                                      //yellow container with icon when no photos available
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height * 0.7,
                                      color: Theme.of(context).primaryColor,
                                      child: Icon(
                                        Icons.deck_rounded,
                                        size: 200,
                                      ),
                                    ),
//Name field
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 80,
                                  width: _isTablet
                                      ? MediaQuery.of(context).size.width / 2 - 8
                                      : MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.black.withOpacity(0),
                                    ],
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 40,
                                      right: 40,
                                    ),
                                    child:
//Name
                                        //using column to top-center the name in gradient background
                                        Column(
                                      children: [
                                        AutoSizeText(_selectedPub?.name ?? 'noPetSelected',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.headline1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

//Top curved border
                              Positioned(
                                bottom: -1,
                                child: Container(
                                  width: _isTablet
                                      ? MediaQuery.of(context).size.width / 2 - 8
                                      : MediaQuery.of(context).size.width,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(150),
                                        topLeft: Radius.circular(150)),
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

//Back Arrow button animated
                              Visibility(
                                visible: !_isTablet,
                                child: Positioned(
                                  top: 40,
                                  left: _isTablet ? 32 : 16,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: AnimatedBuilder(
                                      animation: _controllerIntro,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(32),
                                            color: Colors.black26),
                                        width: _isTablet ? 64 : 40,
                                        height: _isTablet ? 64 : 40,
                                        child: Padding(
                                          padding: _isTablet
                                              ? const EdgeInsets.only(left: 16)
                                              : const EdgeInsets.only(left: 8),
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            size: _isTablet ? 40 : 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      builder: (context, child) {
                                        return Transform(
                                            child: child,
                                            transform: Matrix4.translationValues(
                                                Tween<double>(begin: -60, end: 0)
                                                    .animate(CurvedAnimation(
                                                        parent: _controllerIntro,
                                                        curve: Interval(0, 1,
                                                            curve: Curves.elasticOut)))
                                                    .value,
                                                0,
                                                0));
                                      },
                                    ),
                                  ),
                                ),
                              ),

//review - animated
                              Positioned(
                                  top: 40,
                                  right: _isTablet ? 32 : 16,
                                  child: AnimatedBuilder(
                                    animation: _controllerIntro,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: _isTablet ? 16 : 12, vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(32),
                                          color: Colors.black26),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: _isTablet ? 32 : 20,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8, top: 4),
                                            child: Text(_selectedPub?.reviewScore?? 'noPetSelected' + '/6',
                                                style: _isTablet
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                    : Theme.of(context).textTheme.headline2),
                                          )
                                        ],
                                      ),
                                    ),
                                    builder: (context, child) {
                                      return Transform(
                                          child: child,
                                          transform: Matrix4.translationValues(
                                              Tween<double>(begin: 68, end: 0)
                                                  .animate(CurvedAnimation(
                                                      parent: _controllerIntro,
                                                      curve:
                                                          Interval(0, 1, curve: Curves.elasticOut)))
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
                          padding: EdgeInsets.only(left: 32, right: 32, top: 16),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Theme.of(context).canvasColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(Strings.address,
                                  style: _isTablet
                                      ? Theme.of(context).textTheme.headline3
                                      : Theme.of(context).textTheme.headline5),
                              Container(
                                height: 8,
                              ), //spacer
//street + number
                              Row(
                                children: [
                                  AutoSizeText(
                                      _selectedPub?.location.address.street?? 'noPetSelected',
                                      style: _isTablet
                                          ? Theme.of(context).textTheme.headline4
                                          : Theme.of(context).textTheme.headline6),
                                  Container(width: 8,),//spacer
                                  AutoSizeText(
                                          _selectedPub?.location.address.number?? 'noPetSelected',
                                      style: _isTablet
                                          ? Theme.of(context).textTheme.headline4
                                          : Theme.of(context).textTheme.headline6),
                                ],
                              ),
//district
                              AutoSizeText(_selectedPub?.location.address.district?? 'noPetSelected',
                                  style: _isTablet
                                      ? Theme.of(context).textTheme.headline4
                                      : Theme.of(context).textTheme.headline6),
//zipcode + city
                              Row(
                                children: [
                                  AutoSizeText(
                                      _selectedPub?.location.address.zipcode?? 'noPetSelected',
                                      style: _isTablet
                                          ? Theme.of(context).textTheme.headline4
                                          : Theme.of(context).textTheme.headline6),
                                  Container(width: 8,),
                                  AutoSizeText(
                                      _selectedPub?.location.address.city?? 'noPetSelected',
                                      style: _isTablet
                                          ? Theme.of(context).textTheme.headline4
                                          : Theme.of(context).textTheme.headline6),
                                ],
                              ),
//country
                              AutoSizeText(
                                  _selectedPub?.location.address.country?? 'noPetSelected',
                                  style: _isTablet
                                      ? Theme.of(context).textTheme.headline4
                                      : Theme.of(context).textTheme.headline6),
                            ],
                          ),
                        )
                      ],
                    )

//no item selected
                  : Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.black26, borderRadius: BorderRadius.circular(32)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Strings.clickForDetails,
                              style: _isTablet
                                  ? Theme.of(context).textTheme.headline2
                                  : Theme.of(context).textTheme.bodyText1,
                            ),
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
