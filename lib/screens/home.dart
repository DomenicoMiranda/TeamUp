import 'package:flutter/material.dart';
import 'package:teamup/authentication/login.dart';
import 'package:teamup/authentication/resetpassword.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: 
        Column(children: [
        FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Container(
              height: 20,
              width: 60,
              color: Colors.red)),
              FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Resetpassword()),
              );
            },
            child: Container(
              height: 20,
              width: 60,
              color: Colors.black)),])
      ),
    );
  }
}
