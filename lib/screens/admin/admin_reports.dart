import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamup/models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/screens/admin/admin_report_details.dart';

class AdminReports extends StatefulWidget {
  @override
  _AdminReportsState createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  List<Report> reportList;

  @override
  void initState() {
    getReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SEGNALAZIONI"),
          centerTitle: true,
        ),
        body: Container(
          child: StreamBuilder(
            stream: Firestore.instance.collection('reports').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      return Container(

                          height:100,

                          child: GestureDetector(
                            onTap: () {

                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (_) => AdminReportDetails(
                                        projectId: ds.data["projectId"],
                                        uid: ds.data["userId"],
                                        content: ds.data["content"],
                                        projectName: ds.data["projectName"],
                                        documentId:  ds.documentID,
                                      )
                                  )
                              );
                            },
                              child: cardReport(ds.data["projectName"])));
              });
              }else return CircularProgressIndicator();
            },
          ),
        )
    );
  }

  getReports() async {
    Firestore.instance.collection('projects').snapshots();

  }
}

Widget cardReport(String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: new BoxDecoration(
            //color: Colors.blueGrey.shade200,
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(10.0),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: new Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
              textAlign: TextAlign.center,
            ),
          )
      ),
  );
}
