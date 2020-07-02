import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Applications extends StatefulWidget {
  @override
  ApplicationsState createState() => ApplicationsState();
}

class ApplicationsState extends State<Applications> {

  List<Widget> containerApplications = [
    buildCandidature(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: DefaultTabController(
        length: 3,
        child: new Scaffold(
            appBar: new AppBar(
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
              children: containerApplications,
            )

        ),
      ),
    );
  }

}

@override
Widget buildCandidature() {
  return Container(
    child: StreamBuilder(
        stream: Firestore.instance
            .collection('applications')
            //TODO modificare query ed inserire un where UID current user == candidatura (rif. myprojects.dart)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data.. Please wait');
          return ListView(
            children: snapshot.data.documents.map<Widget>((document) {
              return buildListCandidature(document['candidature'].toString());
            }).toList(),
          );
        }
    )
  );
}

Widget buildListCandidature(String title) {
  return new Container(
    height: 100.0,
    child: Card(
    child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8.0, bottom: 8.0, top: 8.0),
        child: ListTile(
          //leading: const Icon(Icons.account_circle),
          leading: CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage("https://www.clipartmax.com/png/middle/248-2487966_matthew-man-avatar-icon-png.png")),
          trailing: MaterialButton(child: Text("Accetta"), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green.shade500)),
            //TODO dichiarare funzione onPressed per il button accettaCandidato()
            onPressed: () { },
          ),
          title: new Text(title),
          //TODO onTap della Card >> visualizza profilo utente
          //onTap: () {  }
        ),
      ),
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
                      padding: const EdgeInsetsDirectional.only(bottom:30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(document['name'],
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700)),
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
                          document['ownerName'] + " " + document['ownerSurname'],
                          textAlign: TextAlign.left, style: TextStyle(color: Colors.grey.shade700),
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
                      if(document['maxTeammate'] != null && document['maxTeammate'] != document['teammate'].length)
                        Text((document['maxTeammate'] - document['teammate'].length).toString(),
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
                      if(document['maxTeammate'] == document['teammate'].length)
                        Text("Completo",style: TextStyle(
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