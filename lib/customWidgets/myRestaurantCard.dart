import 'package:flutter/material.dart';

class MyRestaurantCard extends StatelessWidget {
  final Function() onTap;

  const MyRestaurantCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(16)
          ),
        ));
  }
}
