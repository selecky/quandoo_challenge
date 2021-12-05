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
  String actualPhotoUrl;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);
  }

  @override
  void dispose() {
    _tabController?.dispose();
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

                  pubPhotosList = [];

                  pubPhotosList =
                      _selectedPub.images?.map((e) => e.url)?.toList();

                  if (pubPhotosList.isNotEmpty) {
                    actualPhotoUrl = pubPhotosList[0];
                  }

                  _tabController = TabController(
                      length: _selectedPub.images.length, vsync: this);

                  _tabController.addListener(() {
                    setState(() {
                      actualPhotoUrl = pubPhotosList[_tabController.index];
                    });
                  });

                  return _selectedPub != null

//photos in TabBarView
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: pubPhotosList.isEmpty
                          //display only icon when not photos for restaurant available
                              ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            color: Theme.of(context).primaryColor,
                            child: Icon(Icons.deck_rounded, size: 200,),
                          )
                              : TabBarView(
                                  controller: _tabController,
                                  children:
                                      pubPhotosList.map((String currentURL) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _tabController.index <
                                                  pubPhotosList.length - 1
                                              ? _tabController.index++
                                              : _tabController.index = 0;
                                        });
                                      },
                                      child: Container(
                                        width: 500,
                                        height: 500,
                                        child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Image.network(
                                              currentURL,
                                              cacheWidth: 500,
                                              errorBuilder: (
                                                BuildContext context,
                                                Object error,
                                                StackTrace stackTrace,
                                              ) {
                                                if (error.toString().contains(
                                                    'statusCode: 404')) {
                                                  print('hovno1');
                                                  print(error.toString());
                                                  return Padding(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Icon(
                                                        Icons.not_interested,
                                                        color: Colors.white,
                                                      ));
                                                }
                                                print('hovno2');
                                                print(error.toString());
                                                return Padding(
                                                    padding: EdgeInsets.all(16),
                                                    child: Icon(
                                                      Icons.refresh,
                                                      color: Colors.white,
                                                    ));
                                              },
                                            )),
                                      ),
                                    );
                                  }).toList(),
                                ),
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
