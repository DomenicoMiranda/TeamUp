import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/authentication/login.dart';
import 'package:teamup/database/auth.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/user.dart';
import 'package:teamup/screens/home.dart';
import 'package:getflutter/getflutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/widgets/loading.dart';
import '../widgets/destinationView.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  FirebaseUser firebaseUser;
  UserData user;
  var uid;
  bool loading = true;
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Profilo"),
          centerTitle: true,
        ),
        body: wrapper());
  }

  wrapper() {
    if (firebaseUser != null) {
      getData();
      return loading ? Loading() : loggedIn();
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
          color: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("LOGIN",textAlign: TextAlign.center,),
            ))
      ]),
    ));
  }

  loggedIn() {
    return SingleChildScrollView(
        child: Center(
      child:
      Column(
        children: [
          new GFAvatar(
            maxRadius: 50,
            backgroundImage: NetworkImage("https://i1.sndcdn.com/avatars-000673793789-z0ovap-t500x500.jpg"),
            shape: GFAvatarShape.circle,
          ),
          RaisedButton(
            onPressed: (){},
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("CARICA CV"),
            ),
          ),
          Card(
            child: Container(
              child: Column(
                children: [
                  Text("I MIEI DATI"),
                  Row(
                    children: [
                      Text("Nome: "),
                      Text(user.name)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Cognome: "),
                      Text(user.surname)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Nickname: "),
                      Text(user.nickname)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Email: "),
                      Text(user.email)
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              child: Column(children: [
                Text("LE MIE COMPETENZE"),
              ],)
            ),
          ),
          RaisedButton(
            onPressed: () async {
              await AuthService().signOut();
              return new DestinationView();
            },
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("LOGOUT"),
            ),
          ),
        ],
      ),
    ));
  }

  getUser()async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.toString());
    setState(() {
      
    });
  }

  getData() async {
        uid = firebaseUser.uid;
        user = await DatabaseService().getUserData(uid);
        print(user.nickname);
        if(mounted){
        setState(() {
          loading = false;
        });}
  }

}
