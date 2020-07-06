import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/widgets/loading.dart';


class Applications extends StatefulWidget {
  @override
  ApplicationsState createState() => ApplicationsState();
}

class ApplicationsState extends State<Applications> {

  FirebaseUser firebaseUser;
  String uid;
  UserData user;
  bool loading = true;
  List<Widget> containerApplications;

  @override
  void initState() {
    getUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Container(
      child: DefaultTabController(
        length: 3,
        child: new Scaffold(
            appBar: new AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Candidature'),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                        isScrollable: false, tabs: [
                      new Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: new Tab(text: 'IN ATTESA')
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: new Tab(text: 'CONFERMATE'),
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: new Tab(text: 'SCADUTE'),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            /*body: new TabBarView(
                  children: [
                    new ListView(
                      children: list,
                    ),
                    new ListView(
                      children: list,
                    ),
                  ],
                ),*/
            body: TabBarView(
              children: containerApplications = [
                buildCandidature(),
                buildCandidatureConfermate(),
                Container(),
              ],
            )

        ),
      ),
    );
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
Widget buildCandidature() {
  return Container(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('applications')
              .where("utente", isEqualTo: firebaseUser.uid)
              .where("statoCandidatura", isEqualTo: 1)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading data.. Please wait');
            return ListView(
              children: snapshot.data.documents.map<Widget>((document) {
                return buildListCandidature(document);
              }).toList(),
            );
          }
      )
  );
}

  Widget buildCandidatureConfermate() {
    return Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('applications')
                .where("utente", isEqualTo: firebaseUser.uid)
                .where("statoCandidatura", isEqualTo: 0)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading data.. Please wait');
              return ListView(
                children: snapshot.data.documents.map<Widget>((document) {
                  return buildListCandidatureConfermate(document);
                }).toList(),
              );
            }
        )
    );
  }


Widget buildListCandidature(DocumentSnapshot application) {
  return new Container(
    height: 100.0,
    child: Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8.0, bottom: 8.0, top: 8.0),
        child: ListTile(
          //leading: const Icon(Icons.account_circle),
          trailing: MaterialButton(child: Text("Elimina candidatura"), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red.shade500)),
            onPressed: () {
                  DatabaseService().deleteCandidatura(application.documentID);
            },
          ),
          title: new Text(application['progettoCandidatura']),
          subtitle:
              application['statoCandidatura'] == 1 ?  Text("In attesa") : null,
          //new Text("STATO CANDIDATURA"),
          //TODO onTap della Card
          onTap: () {  }
        )
      ),
    ),
  );
}


  Widget buildListCandidatureConfermate(DocumentSnapshot application) {
    return new Container(
      height: 100.0,
      child: Card(
        child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0, bottom: 8.0, top: 8.0),
            child: ListTile(
              //leading: const Icon(Icons.account_circle),
                trailing: MaterialButton(child: Text("Confermata"), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)),
                  onPressed: () {
                    return null;
                  },
                ),
                title: new Text(application['progettoCandidatura']),
                //new Text("STATO CANDIDATURA"),
                //TODO onTap della Card
                onTap: () {  }
            )
        ),
      ),
    );
  }

}