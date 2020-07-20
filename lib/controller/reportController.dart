import 'package:teamup/models/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReportController{

  final CollectionReference reportCollection = Firestore.instance.collection('report');
  final Firestore _firestoreInstance = Firestore.instance;



  Future addReport(Report report) async {
    await _firestoreInstance
        .collection("reports")
        .document(report.uid)
        .setData(report.toMap());
  }

  Future deleteReport(String uid) async {
    await _firestoreInstance
        .collection("reports")
        .document(uid)
        .delete();
  }

}