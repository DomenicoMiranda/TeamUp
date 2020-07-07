import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/models/user.dart';
import 'package:teamup/screens/application_user_profile.dart';



class ProjectApplications extends StatefulWidget {

  ProjectApplications({this.userName, this.statoCand, this.projectApplication, this.projectID});
  var userName;
  var statoCand;
  var projectApplication;
  var projectID;

  @override
  _ProjectApplicationsState createState() => _ProjectApplicationsState();
}

class _ProjectApplicationsState extends State<ProjectApplications> {

  FirebaseUser firebaseUser;
  UserData user;
  String uid;
  bool loading = true;
  ProjectData project = new ProjectData();


  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    await getData();
    setState(() {
      loading = false;
    });
  }

  getData() async {
    uid = firebaseUser.uid;
    user = await DatabaseService().getUserData(uid);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Candidature Mio Progetto'),
        centerTitle: true,
      ),
      body: buildCandidatureToMyProjects(),
    );
  }



Widget buildCandidatureToMyProjects() {
  return Container(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('applications')
              .where("progettoID", isEqualTo: widget.projectID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading data.. Please wait');
            return ListView(
              children: snapshot.data.documents.map<Widget>((document) {
                return buildListCandidaturetoMyProjects(document);
              }).toList(),
            );
          }
      )
  );
}

Widget buildListCandidaturetoMyProjects(DocumentSnapshot application) {
  return new Container(
    height: 100.0,
    child: Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8.0, bottom: 8.0, top: 8.0),
        child: ListTile(
          //leading: const Icon(Icons.account_circle),
          trailing: MaterialButton(child: Text("Visualizza"), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green.shade500)),
            onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => ApplicationUserProfile(uid: application["utente"], projectId: application["progettoID"], applicationID: application.documentID,),
                  ));
            },
          ),
          title: new Text(application['progettoCandidatura']),
          subtitle: new Text(application['name'] + " " + application['surname']),
          //onTap: () {  }
        ),
      ),
    ),
  );
}
}