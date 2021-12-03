import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/detail.dart';
import 'package:quandoo_challenge/master.dart';
import 'package:quandoo_challenge/strings.dart';

import 'blocks/bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PubBloc(StatePubsLoading()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.title,
        theme: ThemeData(

          primarySwatch: Colors.green,

          primaryColor: Color(0xff6a1b9a),
          primaryColorDark: Color(0xff4a148c),
          primaryColorLight: Color(0xff7b1fa2),

          // secondary color
          accentColor: Color(0xfffdd835),

          // secondary color Light
          highlightColor: Color(0xffffeb3b),

          // primary color Dark
          hintColor: Color(0xff4a148c),

          buttonColor: Colors.black.withOpacity(0.75),

          fontFamily: 'Rounded',

          textTheme: TextTheme(
            //Biggest text
            headline1: TextStyle(fontSize: 40.0, color: Colors.white),
            //App bar text
            headline2: TextStyle(fontSize: 20.0, color: Colors.white),
            //Black text
            headline3: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            //Grey text
            headline4: TextStyle(fontSize: 14.0),
            //White text
            headline5: TextStyle(fontSize: 14.0, color: Colors.white),
            //App bar text - black
            headline6: TextStyle(fontSize: 14.0,),
          ),


        ),
        home: MyHomePage(title: Strings.title),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < constraints.maxHeight) {
            return MobileView();
          } else {
            return TabletView();
          }
        }
    );
  }
}

class MobileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Master();
  }
}

class TabletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Master()),
        Container(width: 16, height: MediaQuery.of(context).size.height,),
        Expanded(child: Detail())
      ],
    );
  }
}
