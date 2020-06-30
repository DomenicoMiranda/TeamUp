import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
    String uid;
    String userId;
    String projectId;
    String content;

   Report({String userId, String projectId, String uid, String content}){
     this.projectId = projectId;
     this.content = content;
     this.userId = userId;
     this.uid = uid;
   }

   Report.fromFirestoreDocumentSnapshot(DocumentSnapshot documentSnapshot) {
     uid = documentSnapshot.documentID;
     userId = documentSnapshot.data['userId'];
     projectId = documentSnapshot.data['projectId'];
     content = documentSnapshot.data["content"];
   }

   Map<String, dynamic> toMap(){
     var data = {
       "userId" : userId,
       "projectId" : projectId,
       "content" :  content
     };
     return data;
   }

}