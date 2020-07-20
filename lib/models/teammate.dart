import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class User {

final String uid;

  User ({ this.uid });

}

class UserData {

   String uid;
   String name;
   String surname;
   String email;
   String nickname;
   int  admin;
   String image;
   String date;
   String cv;
   int avaiableSponsor = 0;

  UserData({String uid, String name, String surname, String email, String nickname, int admin, String image, String date, String cv, int avaiableSponsor}){
    this.uid = uid;
    this.name = name; 
    this.surname = surname; 
    this.email = email; 
    this.nickname = nickname; 
    this.admin = admin;
    this.image = image;
    this.date = date;
    this.cv = cv;
    this.avaiableSponsor = avaiableSponsor;
    }

  UserData.fromFirestoreDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.documentID;
    admin = documentSnapshot.data['admin'];
    name = documentSnapshot.data['name'];
    surname = documentSnapshot.data['surname'];
    email = documentSnapshot.data['email'];
    date = documentSnapshot.data["date"];
    if(documentSnapshot.data["image"] == null){
      image = "https://i1.sndcdn.com/avatars-000673793789-z0ovap-t500x500.jpg";
    }else
    image = documentSnapshot.data["image"];
    cv = documentSnapshot.data["cv"];
    avaiableSponsor = documentSnapshot.data["num_sponsor"];
  }


  getUser(String uid) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser != null) {
      uid = firebaseUser.uid;
      return uid;
    }
  }

  getCurrentUser(FirebaseUser firebaseUser) async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    return firebaseUser;
  }

   Future<UserData> getUserData( String uid) async {
     DocumentSnapshot documentSnapshot = await Firestore.instance
         .collection("users")
         .document(uid)
         .get();

     return UserData.fromFirestoreDocumentSnapshot(documentSnapshot);
   }

   UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
     return UserData(
       uid: uid,
       name: snapshot.data['name'],
       surname: snapshot.data['surname'],
       email: snapshot.data['email'],
       admin: snapshot.data['admin'],
     );
   }

   //get user stream
   Stream<QuerySnapshot> get users {
     return Firestore.instance.collection('users').snapshots();
   }

   // get user doc stream
   Stream<UserData>  userData(String uid) {

     return Firestore.instance.collection('users').document(uid).snapshots()
         .map(_userDataFromSnapshot);
   }



}