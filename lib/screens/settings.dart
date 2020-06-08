import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/database/auth.dart';
import 'package:teamup/screens/home.dart';

import '../widgets/destinationView.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  var firebaseUser;
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profilo"),
          centerTitle: true,
        ),
        body: wrapper());
  }

  wrapper() {
    if (firebaseUser != null) {
      return loggedIn();
    } else {
      print("not logged");
      return notLoggedIn();
    }
  }

  notLoggedIn() {
    return SingleChildScrollView(
        child: Center(
      child: Column(children: [
        Container(
            height: 200,
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              "Per poter accedere alle funzionalità dell'app devi essere registrato",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            )),
        RaisedButton(
            onPressed: null,
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("LOGIN"),
            ))
      ]),
    ));
  }

  loggedIn() {
    return SingleChildScrollView(
        child: Center(
      child: RaisedButton(
        onPressed: () async {
          await AuthService().signOut();
          return new DestinationView();
        },
        child: Container(
          height: 30,
          width: MediaQuery.of(context).size.width / 2,
          child: Text("LOGOUT"),
        ),
      ),
    ));
  }

  getUser()async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    setState(() {
      
    });
  }
}
