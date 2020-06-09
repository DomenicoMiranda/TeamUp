import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/models/user.dart';
import 'auth.dart';


class DatabaseService {

  final String uid;  //UID USER 


  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference childrenCollection = Firestore.instance.collection('projects');
  final CollectionReference postsCollection = Firestore.instance.collection('report');
  final Firestore _firestoreInstance = Firestore.instance;

  AuthService auth = AuthService();


  // add/update user data
  Future updateUserData(String name, String surname, String email, String nickname, bool admin) async {

    return await usersCollection.document(uid).setData({
      'name': name,
      'surname': surname,
      'email' : email,
      'nickname' : nickname,
      'admin' : false,
    });
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







}

