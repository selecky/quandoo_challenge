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
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PubBloc(repository: repository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.title,
        theme: ThemeData(

          primarySwatch: Colors.amber,

          primaryColor: Colors.amber[600],
          primaryColorDark: Colors.amber[700],
          primaryColorLight: Colors.amber,

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
                fontSize: 20.0,
                color: Colors.black,
                ),
            //Grey text
            headline4: TextStyle(fontSize: 20.0),
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

  bool isLandscape;

  @override
  Widget build(BuildContext context) {

    isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    if(MediaQuery.of(context).size.shortestSide < 600){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
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
        Container(width: 16, height: MediaQuery.of(context).size.height),
        Expanded(child: Detail())
      ],
    );
  }
}
