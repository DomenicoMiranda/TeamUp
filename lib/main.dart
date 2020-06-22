import 'package:flutter/material.dart';
import 'package:teamup/user_not_logged_in/home_not_logged.dart';
import 'package:teamup/widgets/destinationView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'authentication/login.dart';
import 'authentication/sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TeamUp',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('it', 'IT'),
      ],
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        accentColor: Color(0xFFFEF9EB),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DestinationView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
      ),
      body: Center(
      ),
    );
  }
}
