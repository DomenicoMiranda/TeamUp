import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_selector.dart';

class CardView extends StatefulWidget {

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  DocumentSnapshot document;
  CategorySelectorState _c = CategorySelectorState();
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  initState() {
    controller.addListener(() {
      setState(() {
        filter = _c.selectedCategory;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
       Container(
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

    @override
    Widget build(BuildContext context) {
      return Container(
        child: StreamBuilder(
            stream: Firestore.instance.collection('projects').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading');
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return filter == null || filter == "" ?
                  new Container() :
                      _buildListItem(context, snapshot.data.documents[index]);
                }

              );
            }
        ),
      );
    }
}