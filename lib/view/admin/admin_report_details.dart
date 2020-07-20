import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teamup/controller/reportController.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/user.dart';
import 'package:teamup/view/admin/admin_reports.dart';
import 'package:teamup/view/project/project_details.dart';
import 'package:teamup/widgets/loading.dart';

class AdminReportDetails extends StatefulWidget {
  AdminReportDetails(
      {this.uid, this.projectId, this.content, this.projectName, this.documentId});

  final String documentId;
  final String content;
  final String uid;
  final String projectId;
  final String projectName;

  @override
  _AdminReportDetailsState createState() => _AdminReportDetailsState();
}

class _AdminReportDetailsState extends State<AdminReportDetails> {
  bool loading = true;
  UserData user;
  ProjectData projectData;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("DETTAGLI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(children: [
                          Text(
                            "Nome progetto",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.projectName),
                        ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(children: [
                          Text(
                            "Segnalazione effettuata da:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(user.name+" "+user.surname),
                        ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        child: Column(children: [
                          Text(
                            "Segnalazione",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.content),
                        ])),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minWidth: double.infinity,
                    height: 50,
                    color: Colors.blue.shade500,
                    onPressed: ()

                           {

                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => ProjectDetails(
                                  title: projectData.name,
                                  description: projectData.description,
                                  uid: projectData.id,
                                  qualities: projectData.qualities,
                                    owner: projectData.ownerId,
                                    name: projectData.ownerName,
                                    surname: projectData.ownerSurname,
                                    ownerImage: projectData.ownerImage,
                                    cv: user.cv,
                                  teammates: projectData.teammate,
                                  maxTeammate: projectData.maxTeammate,

                           )
                            )
                        );


                    },
                    child: Text("Vai al progetto",
                        style: TextStyle(color: Colors.white)),
                  ),

                  SizedBox(height: 15),

                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minWidth: double.infinity,
                    height: 32,
                    color: Colors.redAccent.shade700,
                    onPressed: () {
                      ReportController().deleteReport(widget.documentId);
                      Navigator.push(context,
                          MaterialPageRoute(
                          builder: (_) => AdminReports()));
                    },
                    child: Text("Elimina segnalazione",
                        style: TextStyle(color: Colors.white)),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getData() async {
    user = await UserData().getUserData(widget.uid);
    projectData = await ProjectData().getProjectData(widget.projectId);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
