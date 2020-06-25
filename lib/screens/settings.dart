import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/authentication/login.dart';
import 'package:teamup/database/auth.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/user.dart';
import 'package:getflutter/getflutter.dart';
import 'package:teamup/screens/profile/editprofile.dart';
import 'package:teamup/widgets/loading.dart';
import '../widgets/destinationView.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  FirebaseUser firebaseUser;
  UserData user;
  var uid;
  bool loading = true;
  String _uploadedCvURL;
  String _currentCv;

  File _cv;



  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Profilo"),
          centerTitle: true,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile(user: this.user, uid: this.uid,)),
              );
              },
            ),
          ]
        ),
        body: wrapper());
  }

  wrapper() {
    if (firebaseUser != null) {
      getData();
      return loading ? Loading() : loggedIn();
    } else {
      print("not logged");
      return notLoggedIn();
    }
  }

  notLoggedIn() {
    return SingleChildScrollView(
        child: Center(
      child: Column(children: [
        Container(
            height: 200,
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              "Per poter accedere alle funzionalità dell'app devi essere registrato",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            )),
        RaisedButton(
          color: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("LOGIN",textAlign: TextAlign.center,),
            ))
      ]),
    ));
  }

  loggedIn() {
    return SingleChildScrollView(
        child: Center(
      child:
      Column(
        children: [
          new GFAvatar(
            maxRadius: 50,
            backgroundImage: NetworkImage(user.image),
            shape: GFAvatarShape.circle,
          ),
          RaisedButton(
            onPressed: () => _openFileExplorer(),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("CARICA CV"),
            ),
          ),
          if(_cv != null)
            Text("CV PRESENTE"),
          if(_cv == null)
            Text("CV ASSENTE"),
          Card(
            child: Container(
              child: Column(
                children: [
                  Text("I MIEI DATI"),
                  Row(
                    children: [
                      Text("Nome: "),
                      Text(user.name)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Cognome: "),
                      Text(user.surname)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Nickname: "),
                      Text(user.nickname)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Email: "),
                      Text(user.email)
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              child: Column(children: [
                Text("LE MIE COMPETENZE"),
              ],)
            ),
          ),
          RaisedButton(
            onPressed: () async {
              await AuthService().signOut();
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DestinationView()));
            
             
            },
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("LOGOUT"),
            ),
          ),
        ],
      ),
    ));
  }

  getUser()async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.toString());
    setState(() {
      
    });
  }

  getData() async {
        uid = firebaseUser.uid;
        user = await DatabaseService().getUserData(uid);
        print(user.nickname);
        if(mounted){
        setState(() {
          loading = false;
        });}
  }

  _openFileExplorer() async {
    File file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['pdf']);

    setState(() {
      _cv = file;
      uploadCv();

    });
  }

  Future uploadCv() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Curriculum/${Path.basename(_cv.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_cv);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedCvURL = fileURL;
        _currentCv = _uploadedCvURL;
      });
    });
  }


}
