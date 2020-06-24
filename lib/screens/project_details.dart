import 'package:flutter/material.dart';
import 'package:teamup/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectDetails extends StatefulWidget {
  ProjectDetails({this.title, this.description, this.qualities, this.uid, this.category});
  var title;
  var description;
  List<dynamic> qualities;
  var category;
  var uid;
  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DETTAGLI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.title),
            Text(widget.uid),
            Text(widget.description),
            Text(widget.qualities.toString()),
          ],
        ),
      ),
    );
  }
}
