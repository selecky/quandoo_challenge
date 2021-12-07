import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quandoo_challenge/blocs/simpleBlocDelegate.dart';
import 'package:quandoo_challenge/repository/repository.dart';
import 'package:quandoo_challenge/screens/detail.dart';
import 'package:quandoo_challenge/screens/master.dart';
import 'package:quandoo_challenge/strings.dart';
import '../blocs/pub_barrel.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();//monitors bloc functionality
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Repository repository = Repository();

  @override
  Widget build(BuildContext context) {

    //to make statusBar and systemNavigationBar dark
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark
    );

    return BlocProvider(
      create: (context) => PubBloc(repository: repository)..add(EventPubsLoad()),//initialize the app with an API call
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.title,
        theme: ThemeData(

          primarySwatch: Colors.amber,
          primaryColor: Colors.amber[600],
          primaryColorDark: Colors.amber[700],
          primaryColorLight: Colors.amber,
          accentColor: Color(0xfffdd835),
          highlightColor: Color(0xffffeb3b),

          fontFamily: 'Rounded',

          textTheme: TextTheme(
            //Biggest white text
            headline1: TextStyle(fontSize: 40.0, color: Colors.white),
            //big white text
            headline2: TextStyle(fontSize: 20.0, color: Colors.white),
            //small white text
            bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
            //Black text
            headline3: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                ),
            //Grey text
            headline4: TextStyle(fontSize: 20.0),
            //black small text
            headline5: TextStyle(fontSize: 16.0, color: Colors.black),
            //grey small text
            headline6: TextStyle(fontSize: 16.0, color: Colors.grey),
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

  bool isLandscape;

  @override
  Widget build(BuildContext context) {

    isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    //force portrait orientation on mobile and landscape on tablet
    if(MediaQuery.of(context).size.shortestSide < 600){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }


    return LayoutBuilder(
        builder: (context, constraints) {
          if (isLandscape) {
            return TabletView();
          } else {
            return MobileView();
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
        Container(width: 16, height: MediaQuery.of(context).size.height),//divider
        Expanded(child: Detail())
      ],
    );
  }
}
