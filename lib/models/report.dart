import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
    String uid;
    String userId;
    String projectId;
    String content;
    String projectName;

   Report({String userId, String projectId, String uid, String content, String projectName}){
     this.projectId = projectId;
     this.content = content;
     this.userId = userId;
     this.uid = uid;
     this.projectName = projectName;
   }

   /*Report.fromFirestoreDocumentSnapshot(DocumentSnapshot documentSnapshot) {
     uid = documentSnapshot.documentID;
     userId = documentSnapshot.data['userId'];
     projectId = documentSnapshot.data['projectId'];
     content = documentSnapshot.data["content"];
     projectName = documentSnapshot.data["projectName"];
   }*/

   Map<String, dynamic> toMap(){
     var data = {
       "userId" : userId,
       "projectId" : projectId,
       "content" :  content,
       "projectName": projectName,
     };
     return data;
   }

}