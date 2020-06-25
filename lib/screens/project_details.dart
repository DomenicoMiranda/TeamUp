import 'package:flutter/material.dart';
import 'package:teamup/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectDetails extends StatefulWidget {


  ProjectDetails({this.title, this.description, this.qualities, this.uid, this.category, this.owner});
  var title;
  var description;
  List<dynamic> qualities;
  var category;
  var uid;
  var owner;

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
            Text(widget.owner),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minWidth: double.infinity,
                height: 32,
                color: Colors.blue.shade500,
                onPressed: () {},
                child: Text("Candidami!",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
