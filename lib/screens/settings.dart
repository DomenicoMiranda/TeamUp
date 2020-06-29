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
import 'package:teamup/widgets/pdf_screen.dart';
import '../widgets/destinationView.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';
import 'package:toast/toast.dart';


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
    return Scaffold(
        appBar:
            AppBar(title: Text("Profilo"), centerTitle: true, actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(
                          user: this.user,
                          uid: this.uid,
                        )),
              );
            },
          ),
        ]),
        body: wrapper());
  }

  wrapper() {
    if (firebaseUser != null) {
      getData();

      return loading ? Loading() : loggedIn();
    } else {
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
              child: Text(
                "LOGIN",
                textAlign: TextAlign.center,
              ),
            ))
      ]),
    ));
  }

  loggedIn() {

    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: [
          new GFAvatar(
            maxRadius: 50,
            backgroundImage: NetworkImage(user.image),
            shape: GFAvatarShape.circle,
          ),
          RaisedButton(
            color: Colors.black54,
            onPressed: () => checkCV(),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("CARICA CV", style: TextStyle(color: Colors.white)),
            ),
          ),
          if (user.cv != null)
          Text("CV PRESENTE"),

          if (user.cv == null)
            Text("CV ASSENTE"),
          Card(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text("I MIEI DATI", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                      color: Colors.black54,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width-100,
                        height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nome", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(user.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                            ],
                          ),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                        color: Colors.black54,
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width-100,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Cognome", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(user.surname, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                              ],
                            ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                        color: Colors.black54,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width-100,
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Email", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(user.email, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
                child: Column(
              children: [
              ],
            )),
          ),
          RaisedButton(
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => DestinationView()));
            },
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Text("LOGOUT"),
            ),
          ),
          RaisedButton(
            child: Text("Open PDF"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PDFScreen(cv: user.cv),
            ),
          ),
          ),          RaisedButton(
            child: Text("check PDF"),
            onPressed: () {
              print("CHECK "+user.cv.toString());
            }
          )

        ],
      ),
    ));
  }

  getUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.toString());
    setState(() {});
  }

  getData() async {
    uid = firebaseUser.uid;
    user = await DatabaseService().getUserData(uid);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  _openFileExplorer() async {
    File file = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['pdf']);

    setState(() {
      _cv = file;

      //DatabaseService(uid: user.uid).updateUserCv(_currentCv);
    });

    uploadCv();

  }

  Future uploadCv() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Curriculum/${Path.basename(_cv.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_cv);
    await uploadTask.onComplete;
    Toast.show("Curriculum caricato correttamente", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedCvURL = fileURL;
        _currentCv = _uploadedCvURL;
      });
    });
  }

  checkCV() async {
    if(user.cv == null){
     await _openFileExplorer();
     uploadCVOnDB();
     print("current cv: "+_currentCv);
    }else{
      Toast.show("Hai già aggiunto il tuo curriculum", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  uploadCVOnDB() {
    DatabaseService(uid: user.uid).updateUserCv(_currentCv);
  }

}
