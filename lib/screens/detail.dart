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

                  if (_selectedPub != null) {
                    pubPhotosList =
                        _selectedPub.images?.map((e) => e.url)?.toList();

                    print(pubPhotosList.length);

                    _tabController = TabController(
                        length: _selectedPub.images.length, vsync: this);
                  }

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
                              : Stack(
                                children: [
                                  //Support containers for immediate caching of all restaurant images (invisible)
                                  // - this helps to prevent bad UX when scrolling the tabBarView
                                  Column(
                                    children: pubPhotosList.map((String photoUrl) {
                                      return Container(
                                          width: 0,
                                          height: 0,
                                          child: Image.network(
                                            photoUrl,
                                            cacheWidth: 500,
                                          )
                                      );
                                    }).toList(),
                                  ),
                                  TabBarView(
                                      key: ObjectKey(pubPhotosList[0]),//without key the TabBarView index does not reset on new restaurant click
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
                                ],
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
