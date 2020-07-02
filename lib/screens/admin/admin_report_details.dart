import 'package:flutter/material.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/user.dart';

class AdminReportDetails extends StatefulWidget {

  AdminReportDetails({this.uid, this.projectId, this.content});

  final String content;
  final String uid;
  final String projectId;
  @override
  _AdminReportDetailsState createState() => _AdminReportDetailsState();
}

class _AdminReportDetailsState extends State<AdminReportDetails> {

  User user;
  ProjectData projectData;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
