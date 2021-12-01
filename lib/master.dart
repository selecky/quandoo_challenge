import 'package:flutter/material.dart';

import 'customWidgets/myRestaurantCard.dart';

class Master extends StatefulWidget {
  const Master({Key? key}) : super(key: key);

  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: GridView.builder(
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2 / 3
          ),
          padding: const EdgeInsets.only(top: 64, bottom: 64, left: 16, right: 16),

          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyRestaurantCard(onTap: () {
                print('Clicked ' + index.toString());
              }),
            );
          }),
    );
  }
}
