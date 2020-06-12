import 'package:flutter/material.dart';
import 'package:teamup/screens/create_project.dart';
import 'package:teamup/widgets/cardView.dart';
import 'package:teamup/authentication/login.dart';
import 'package:teamup/authentication/resetpassword.dart';
import 'package:teamup/widgets/teamView.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProject()),
                );
              },
            ),
          ]

      ),
                  body: CardView(),
    );
  }
}
