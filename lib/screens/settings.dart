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
import 'package:teamup/screens/admin/admin_panel.dart';
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
    return wrapper();
  }

  wrapper() {
    if (firebaseUser != null) {
      getData();

      return loading ? Loading() : loggedIn();
    } else {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child:notLoggedIn());
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
        MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Theme.of(context).primaryColor,
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
                "Login", style: TextStyle(color: Colors.grey.shade200, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
        ),
      ]),
    ));
  }

  loggedIn() {
    return Scaffold(
      appBar:
      AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profilo"),
          centerTitle: true,
          actions: <Widget>[
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
      body:
     Padding(
       padding: const EdgeInsetsDirectional.only(start: 8.0, top: 15, end: 8.0, bottom: 8.0),
       child: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            new GFAvatar(
              maxRadius: 50,
              backgroundImage: NetworkImage(user.image),
              shape: GFAvatarShape.circle,
            ),
            RaisedButton(
              color: Colors.grey.shade100,
              onPressed: () => checkCV(),
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: MediaQuery.of(context).size.width / 2,
                child: Text("CARICA CV", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            if (user.cv != null)
            Text("CV PRESENTE ✔", style: TextStyle(color: Colors.green.shade800),),

            if (user.cv == null)
              Text("CV ASSENTE (completa il profilo)", style: TextStyle(color: Colors.blue.shade700),),

            SizedBox(height: 10, width: MediaQuery.of(context).size.width,),

            Card(
              color: Theme.of(context).accentColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Text("I MIEI DATI", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                          color: Colors.grey.shade100,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width-100,
                            height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Nome", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  Text(user.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.black))
                                ],
                              ),
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                            color: Colors.grey.shade100,
                            child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width-100,
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Cognome", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                    Text(user.surname, textAlign: TextAlign.center, style: TextStyle(color: Colors.black))
                                  ],
                                ),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                            color: Colors.grey.shade100,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width-100,
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("e-mail", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  Text(user.email, textAlign: TextAlign.center, style: TextStyle(color: Colors.black))
                                ],
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
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
              child: Text("Open PDF"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PDFScreen(cv: user.cv),
              ),
            ),
            ),
//          RaisedButton(
//            child: Text("check PDF"),
//            onPressed: () {
//              print("CHECK "+user.cv.toString());
//            }
//          ),
            if(user.admin == 1)
              RaisedButton(
                  color: Colors.green.shade800,
                  child: Text("ADMIN"),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context )=> AdminPanel()
                            )
                    );
                  }
              ),

            SizedBox(height: 40, width: MediaQuery.of(context).size.width),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.redAccent.shade700,
                onPressed: () async {
                  await AuthService().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => DestinationView()));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Text("LOGOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
    )),
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
