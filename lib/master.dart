import 'package:flutter/material.dart';

class Master extends StatefulWidget {
  const Master({Key? key}) : super(key: key);

  @override
  _MasterState createState() => _MasterState();
}

class _MasterState extends State<Master> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(color: Colors.blue,));
  }
}
