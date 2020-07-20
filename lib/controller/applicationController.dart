import 'package:cloud_firestore/cloud_firestore.dart';


class ApplicationController {

  final CollectionReference candidatureCollection = Firestore.instance.collection('applications');
  final Firestore _firestoreInstance = Firestore.instance;


  Future addCandidatura(String userID, String name, String surname, String ownerID, int statoCandidatura, String projectSelected, String idProj) async {
    return await candidatureCollection.document().setData({
      'utente': userID,
      'name': name,
      'surname': surname,
      'ownerID': ownerID,
      'statoCandidatura': statoCandidatura,
      'progettoCandidatura': projectSelected,
      'progettoID': idProj,
    }, merge: true);
  }

  updateStatoCandidatura(String uid, String projectID, String applicationID) async {
    await Firestore.instance.collection("applications").document(applicationID).setData({"statoCandidatura" : 0}, merge: true);
  }


  deleteCandidatura(String projectApplication) async {
    await _firestoreInstance
        .collection("applications")
        .document(projectApplication)
        .delete();
  }

  acceptCandidatura(String uid, String projectId, List<String> teammates) async {
    teammates.add(uid);

    await Firestore.instance.collection('projects').document(projectId).setData({
      'teammate':FieldValue.arrayUnion(teammates)
    }, merge: true);
  }

  refuseCandidatura(String applicationID) async {
    await Firestore.instance.collection("applications").document(applicationID).setData({"statoCandidatura" : 3}, merge: true);
  }

}