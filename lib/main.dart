import 'package:flutter/material.dart';
import 'package:quandoo_challenge/detail.dart';
import 'package:quandoo_challenge/master.dart';
import 'package:quandoo_challenge/strings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.title,
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: Strings.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Master()),
          Expanded(
              flex: 1,
              child: Detail()),
        ],)
    );
  }
}
