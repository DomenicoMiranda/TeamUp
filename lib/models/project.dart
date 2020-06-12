import 'package:cloud_firestore/cloud_firestore.dart';

class Project {

  final String id;

  Project ({ this.id });

}

class ProjectData {

  String id;
  String name;
  String description;
  int maxTeammate;
  String category;
  List<String> teammate = [];

  ProjectData({String id, String name, String description, int maxTeammate, String category, List<String> teammate}){
    this.id = id;
    this.name = name;
    this.description = description;
    this.maxTeammate = maxTeammate;
    this.category = category;
    this.teammate = teammate;
  }

  ProjectData.fromFirestoreDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    name = documentSnapshot.data['name'];
    description = documentSnapshot.data['description'];
    maxTeammate = documentSnapshot.data['maxTeammate'];
    category = documentSnapshot.data['category'];
  }

}
