import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/view/sponsor/sponsor.dart';

class ProjectController{
  final CollectionReference projectCollection = Firestore.instance.collection('projects');
  var _firestoreInstance = Firestore.instance;
  final CollectionReference usersCollection = Firestore.instance.collection('users');



  Future updateProjectData(String id, String name, String description, int maxTeammate, String category, List<String> teammate) async {
    return await projectCollection.document(id).setData({
      'name': name,
      'description': description,
      'maxTeammate' : maxTeammate,
      'category' : category,
      'teammate' : teammate,
    });
  }

  Future addProject(ProjectData project) async {
    await _firestoreInstance
        .collection("projects")
        .document(project.id)
        .setData(project.toMap());
  }

  Future deleteProject(String uid) async {
    await _firestoreInstance
        .collection("projects")
        .document(uid)
        .delete();
  }

  Future addBundlePromoToUser(String currentUser, SignedSponsor bundleSelected, int avaiableSponsor) async {
    if(bundleSelected == SignedSponsor.five) {
      return await usersCollection.document(currentUser).setData({"num_sponsor" : avaiableSponsor+2}, merge: true);
    }
    if(bundleSelected == SignedSponsor.ten) {
      return await usersCollection.document(currentUser).setData({"num_sponsor" : avaiableSponsor+5}, merge: true);
    }
    else {
      return await usersCollection.document(currentUser).setData({"num_sponsor" : 0}, merge: true);
    }
  }

  Future setSponsored(String currentUser, int avaiableSponsor, String projectID) async {
    updateAvaiableSponsorUser(currentUser, avaiableSponsor);
    return await projectCollection.document(projectID).updateData({"sponsor" : true});
  }

  Future updateAvaiableSponsorUser(String currentUser, int avaiableSponsor) async {
    return await usersCollection.document(currentUser).updateData({"num_sponsor" : avaiableSponsor-1});
  }


}