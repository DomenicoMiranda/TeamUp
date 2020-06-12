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
   String image;
   String date;

  UserData({String uid, String name, String surname, String email, String nickname, bool admin, String image, String date}){
    this.uid = uid;
    this.name = name; 
    this.surname = surname; 
    this.email = email; 
    this.nickname = nickname; 
    this.admin = admin;
    this.image = image;
    this.date = date;
    }

  UserData.fromFirestoreDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.documentID;
    admin = documentSnapshot.data['admin'];
    name = documentSnapshot.data['name'];
    surname = documentSnapshot.data['surname'];
    email = documentSnapshot.data['email'];
    nickname = documentSnapshot.data['nickname'];
    date = documentSnapshot.data["date"];
    if(documentSnapshot.data["image"] == null){
      image = "https://i1.sndcdn.com/avatars-000673793789-z0ovap-t500x500.jpg";
    }else
    image = documentSnapshot.data["image"];
  }


}