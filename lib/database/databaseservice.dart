import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/user.dart';
import 'auth.dart';


class DatabaseService {

  final String uid;  //UID USER
  final String id; //ID PROJECT


  DatabaseService({ this.uid, this.id });

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference projectCollection = Firestore.instance.collection('projects');
  final CollectionReference postsCollection = Firestore.instance.collection('report');
  final CollectionReference candidatureCollection = Firestore.instance.collection('applications');
  final Firestore _firestoreInstance = Firestore.instance;

  AuthService auth = AuthService();

  //----------------USER------------------

  // add/update user data
  Future updateUserData(String name, String surname, String email, String date, String image, bool admin) async {

    return await usersCollection.document(uid).setData({
      'name': name,
      'surname': surname,
      'email' : email,
      'date' : date,
      'image' : image,
      'admin' : false,
    });
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

  Future addCandidatura(Map<String, dynamic> m, String projectSelected) async {
    return await candidatureCollection.document(projectSelected).setData({
      'candidature': m,

    });
  }

}



