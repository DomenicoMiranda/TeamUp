import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/database/auth.dart';

class MyProjectsList extends StatefulWidget {
  @override
  _MyProjectsListState createState() => _MyProjectsListState();
}

class _MyProjectsListState extends State<MyProjectsList> {

  List<Widget> containersProjects = [

    buildOnHold(),

    buildCompleted(),

  ];

  @override
  Widget build(BuildContext context) {
    //TODO CAPIRE SE IMPORTARE LA CARDVIEW O LASCIARE IL CODICE INTERNAMENTE
    return new Container(
      child: DefaultTabController(
        length: 2,
        child: new Scaffold(
            appBar: new AppBar(
              title: const Text('Miei Progetti'),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20.0),
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
}

@override
Widget buildOnHold() {
  return Container(
    child: StreamBuilder(
        stream: Firestore.instance
            .collection('projects')
            .where("stato", isEqualTo: "0")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading');
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index])
          );
        }
    ),
  );
}

@override
Widget buildCompleted() {
  AuthService authUser = new AuthService();
  return Container(
    child: StreamBuilder(
        stream: Firestore.instance
            .collection('projects')
            .where("stato", isEqualTo: "1")
            .where("ownerId", isEqualTo: authUser.currentUser())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading');
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index])
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
        height: 200.0,
        //margin: new EdgeInsets.only(right: 46.0),
        decoration: new BoxDecoration(
          //color: Colors.blueGrey.shade200,
          color: Colors.blueGrey.shade200,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(30.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 10.0),
            ),
          ],
        ),

        //Circle Avatar
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "http://49.231.30.115/emrcleft/assets/images/avatars/avatar2_big@2x.png"),
                  ),

                  SizedBox(width: 20),
                  //titolo e material button
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(document['name'],
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70)),
                        MaterialButton(
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
                      ],),
                  )
                ],
              ),

              SizedBox(height: 3),

              //descrizione Card
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                  ],
                ),
              ),

              SizedBox(height: 40),

              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Num. Posti disponibili", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70)),
                      Text(document['maxTeammate'].toString(),
                          style: TextStyle(fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: Colors.white54)),
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

