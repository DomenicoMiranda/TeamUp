import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/authentication/login.dart';
import 'package:teamup/screens/create_project.dart';
import 'package:teamup/screens/project_details.dart';
import 'package:teamup/widgets/loading.dart';



class MyProjectsList extends StatefulWidget {
  @override
  _MyProjectsListState createState() => _MyProjectsListState();
}

class _MyProjectsListState extends State<MyProjectsList> {

  static FirebaseUser firebaseUser;
  //TODO modificare query per recuperare correttamente currentUser e mostrare MIEI PROGETTI
   static String uid;
   bool loading = true;
  List<Widget> containersProjects = [];

  @override
  void initState() {

    //getUid();
getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading? Loading() : firebaseUser == null? notLoggedIn() : Container(
      child: DefaultTabController(
        length: 2,
        child: new Scaffold(
            appBar: new AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Miei Progetti'),
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
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                        isScrollable: false, tabs: [
                      new Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: new Tab(text: 'IN CORSO')
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: new Tab(text: 'COMPLETATO'),
                      )
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
              children: containersProjects,
            )

        ),
      ),
    );
  }

  notLoggedIn() {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
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
              MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).primaryColor,
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
                    child: Text(
                      "Login", style: TextStyle(color: Colors.grey.shade200, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
              ),
            ]),
          ),
        ));
  }



  Future getUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
   if(firebaseUser != null){ uid = firebaseUser.uid;
    if(mounted){
    setState(() {
      containersProjects= [
        buildOnHold(uid),
        buildCompleted(uid),
      ];
      loading = false;
    });
  }}else
    {
      setState(() {
        loading=false;
      });
    }
   }

}

Widget buildOnHold(String uid) {
  print(uid);
  return Container(
    child: StreamBuilder(
        stream: Firestore.instance
            .collection('projects')
            .where("ownerId", isEqualTo: uid)
            .where("status", isEqualTo: "0")
            .snapshots(),
        builder: (context, snapshot) {
          print("ciao");
          if(snapshot.data == null ){
            return Loading();}else{
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ProjectDetails(
                                    title: snapshot.data.documents[index]['name'],
                                    description:snapshot.data.documents[index]['description'],
                                    uid: snapshot.data.documents[index].documentID,
                                    qualities: snapshot.data.documents[index]['qualities'],
                                    owner: snapshot.data.documents[index]['ownerId'],
                                    name: snapshot.data.documents[index]['ownerName'],
                                    surname: snapshot.data.documents[index]['ownerSurname'],
                                    ownerImage: snapshot.data.documents[index]['ownerImage'],
                                    cv: snapshot.data.documents[index]['cv'],
                                    teammates: snapshot.data.documents[index]['teammate'],
                                    maxTeammate: snapshot.data.documents[index]['maxTeammate'],
                                )
                        ));
                  },
                  child: _buildListItem(context, snapshot.data.documents[index]))
          );}
        }
    ),
  );
}


Widget buildCompleted(String uid) {
  return Container(
    child: StreamBuilder(
        stream: Firestore.instance
            .collection('projects')
            .where("ownerId", isEqualTo: uid)
        .where("status", isEqualTo: "1")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading');
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ProjectDetails(
                                    title: snapshot.data.documents[index]['name'],
                                    description:snapshot.data.documents[index]['description'],
                                    uid: snapshot.data.documents[index].documentID,
                                    qualities: snapshot.data.documents[index]['qualities'],
                                    owner: snapshot.data.documents[index]['ownerId'],
                                    name: snapshot.data.documents[index]['ownerName'],
                                    surname: snapshot.data.documents[index]['ownerSurname'],
                                    ownerImage: snapshot.data.documents[index]['ownerImage'],
                                    cv: snapshot.data.documents[index]['cv'],
                                    teammates: snapshot.data.documents[index]['teammate'],
                                    maxTeammate: snapshot.data.documents[index]['maxTeammate'],
                                )
                        ));
                  },
                  child: _buildListItem(context, snapshot.data.documents[index]))
          );
        }
    ),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150.0,
        //margin: new EdgeInsets.only(right: 46.0),
        decoration: new BoxDecoration(
          //color: Colors.blueGrey.shade200,
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(30.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: new Offset(0.0, 0.0),
            ),
          ],
        ),

        //Circle Avatar
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        document['ownerImage']),
                  ),

                  SizedBox(width: 20),
                  //titolo e material button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(document['name'],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700)),
                          document['sponsor'] ? Text('Sponsorizzato', style: TextStyle(color: Colors.grey.shade500, fontSize: 12),) : Text(''),
                        ],),
                    ),
                  )
                ],
              ),

              SizedBox(height: 5),

              SizedBox(
                width: double.infinity,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8.0),
                    child: Row(
                      children: [
                        Text(
                          document['ownerName'] + " " +
                              document['ownerSurname'],
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Num. Posti disponibili", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                      if(document['maxTeammate'] != null &&
                          document['maxTeammate'] !=
                              document['teammate'].length)
                        Text((document['maxTeammate'] -
                            document['teammate'].length).toString(),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700)),
                      if(document['maxTeammate'] == null)
                        Text("Illimitati",
                            style: TextStyle(
                              //fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700)),
                      if(document['maxTeammate'] ==
                          document['teammate'].length)
                        Text("Completo", style: TextStyle(
                          //fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

