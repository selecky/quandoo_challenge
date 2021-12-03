import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/strings.dart';

import 'Pub.dart';
import 'blocks/bloc.dart';
import 'customWidgets/myRestaurantCard.dart';
import 'detail.dart';

class Master extends StatefulWidget {
  const Master({Key key}) : super(key: key);

  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  PubBloc _bloc;
  List<Pub> _pubList;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PubBloc>(context);
    _bloc.add(EventPubsLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Strings.pubList),
        ),
        body: BlocBuilder<PubBloc, PubState>(builder: (context, state) {
          if (state is StatePubsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StatePubsLoadSuccess) {

            _pubList = state.pubList;

            return GridView.builder(
                itemCount: _pubList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 3 / 2),
                padding: const EdgeInsets.only(
                    top: 64, bottom: 64, left: 16, right: 16),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyRestaurantCard(
                      onTap: () {
                        _bloc.add(EventPubSelect(_pubList[index]));
                        if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) {
                          Navigator.push(context,  MaterialPageRoute(builder: (context) => Detail()));
                        }
                      },
                      name: _pubList[index].name,
                    ),
                  );
                });

            //StatePubsLoadFail
          } else {
            return Center(child: Text(Strings.errorLoadingPubs));
          }

        }));
  }
}
