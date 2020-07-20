import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/models/project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/models/user.dart';
import 'file:///C:/Users/miran/Documents/GitHub/teamup/lib/view/application/application_user_profile.dart';
import 'package:teamup/widgets/destinationView.dart';



class ProjectApplications extends StatefulWidget {

  ProjectApplications({this.userName, this.statoCand,  this.projectID});
  final String userName;
  final int statoCand;
  final String projectID;

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
    getUser(firebaseUser);
    super.initState();
  }

  getUser(FirebaseUser firebaseUser) async {
    firebaseUser = await UserData().getCurrentUser(firebaseUser);//FirebaseAuth.instance.currentUser();
    await getData(user, firebaseUser);
    setState(() {
      loading = false;
    });
  }

  getData(UserData user, FirebaseUser firebaseUser) async {
    //uid = firebaseUser.uid;
    user = await UserData().getUserData(firebaseUser.uid);
    if (mounted) {
      setState(() {
        loading = false;
      });
      return user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('Candidature Mio Progetto'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => DestinationView()
          )),
        ),
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
              .where("statoCandidatura", isEqualTo: 1)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) return Text('Loading data.. Please wait');
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