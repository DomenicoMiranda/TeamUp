import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/report.dart';
import 'package:teamup/models/user.dart';
import 'package:teamup/screens/sponsor/sponsor.dart';
import 'auth.dart';


class DatabaseService {

  final String uid;  //UID USER
  final String id; //ID PROJECT
  final String idCandidature; //ID APPLICATION


  DatabaseService({ this.uid, this.id, this.idCandidature });

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference projectCollection = Firestore.instance.collection('projects');
  final CollectionReference postsCollection = Firestore.instance.collection('report');
  final CollectionReference candidatureCollection = Firestore.instance.collection('applications');
  final Firestore _firestoreInstance = Firestore.instance;

  AuthService auth = AuthService();

  //----------------USER------------------

  // add/update user data
  Future updateUserData(String name, String surname, String email, String date, String image, int admin) async {

    return await usersCollection.document(uid).setData({
      'name': name,
      'surname': surname,
      'email' : email,
      'date' : date,
      'image' : image,
    }, merge: true);
  }

  Future updateUserCv(String cv) async {

    return await usersCollection.document(uid).updateData({'cv': cv});
  }


  // userData from snapshot
    UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
      return UserData(
        uid: uid,
        name: snapshot.data['name'],
        surname: snapshot.data['surname'],
        email: snapshot.data['email'],
        nickname: snapshot.data['nickmane'],
        admin: snapshot.data['admin'],
      );
    }

  //get user stream
    Stream<QuerySnapshot> get users {
      return usersCollection.snapshots();
    }

    // get user doc stream
    Stream<UserData> get userData {
      
      return usersCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
    }

    Future<UserData> getUserData( String uid) async {
    DocumentSnapshot documentSnapshot = await _firestoreInstance
        .collection("users")
        .document(uid)
        .get();

    return UserData.fromFirestoreDocumentSnapshot(documentSnapshot);
  }


  //--------------------PROJECT-----------------------

  Future updateProjectData(String id, String name, String description, int maxTeammate, String category, List<String> teammate) async {
    return await projectCollection.document(id).setData({
      'name': name,
      'description': description,
      'maxTeammate' : maxTeammate,
      'category' : category,
      'teammate' : teammate,
    });
  }



  //projectData from snapshot
  ProjectData _projectDataFromSnapshot(DocumentSnapshot snapshot) {
    return ProjectData(
      id : id,
      name : snapshot.data['name'],
      description : snapshot.data['description'],
      maxTeammate : snapshot.data['maxTeammate'],
      category : snapshot.data['category'],
    );
  }

  //get user stream
  Stream<QuerySnapshot> get projects {
    return projectCollection.snapshots();
  }

  // get user doc stream
  Stream<ProjectData> get projectData {

    return projectCollection.document(id).snapshots()
        .map(_projectDataFromSnapshot);
  }

  Future<ProjectData> getProjectData(String uid) async {
    DocumentSnapshot documentSnapshot = await _firestoreInstance
        .collection("projects")
        .document(uid)
        .get();

    return ProjectData.fromFirestoreDocumentSnapshot(documentSnapshot);
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

  //---------------------CANDIDATURE----------------------------


  Future addCandidatura(String userID, String name, String surname, String ownerID, int statoCandidatura, String projectSelected, String idProj) async {
    return await candidatureCollection.document().setData({
      'utente': userID,
      'name': name,
      'surname': surname,
      'ownerImage': ownerID,
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



  //-----------------------REPORTS-----------------------------

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




  //-----------------------SPONSORIZZAZIONI-----------------------------

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



