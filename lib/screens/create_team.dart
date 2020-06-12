import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamup/widgets/teamView.dart';

import 'home.dart';

class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Crea Team", style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        )),
        leading:
        IconButton(
          iconSize: 30.0,
          color: Colors.white,
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TeamForms(),
          ],
        ),
      ),
    );
  }
}
