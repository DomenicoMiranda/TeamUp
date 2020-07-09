import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
                          height:30,

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
  return Card(
    child: Container(
        height: 50,
        color: Colors.grey,
        child: Text(title,style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold
        ),
          textAlign: TextAlign.center,
        )
    ),
  );
}
