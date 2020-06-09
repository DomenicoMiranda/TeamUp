import 'package:cloud_firestore/cloud_firestore.dart';


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
   bool  admin;

  UserData({String uid, String name, String surname, String email, String nickname, bool admin}){
    this.uid = uid;
    this.name = name; 
    this.surname = surname; 
    this.email = email; 
    this.nickname = nickname; 
    this.admin = admin;
    }

  UserData.fromFirestoreDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.documentID;
    admin = documentSnapshot.data['admin'];
    name = documentSnapshot.data['name'];
    surname = documentSnapshot.data['surname'];
    email = documentSnapshot.data['email'];
    nickname = documentSnapshot.data['nickname'];
  }


}