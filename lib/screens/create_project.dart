import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamup/widgets/teamView.dart';


class CreateProject extends StatefulWidget {
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Crea Progetto", style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        leading:
        IconButton(
          iconSize: 30.0,
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TeamForms(),
            ],
          ),
        ),
      ),
    );
  }
}
