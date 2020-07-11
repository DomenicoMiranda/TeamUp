import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/user.dart'; 



class EditProfile extends StatefulWidget {
EditProfile({this.user, this.uid});

final UserData user;
final String uid;

 @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }


final _formKey = GlobalKey<FormState>();


String _currentName;
String _currentSurname;
String _currentEmail;
String _currentImage;
String _uploadedFileURL;
String _currentDate;
int _currentSponsor;

Future chooseFile() async {    
   await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {    
     setState(() {    
       _image = image; 
       uploadFile();   
     });    
   });    
 }  
 Future camera() async {    
   await ImagePicker.pickImage(source: ImageSource.camera).then((image) {    
     setState(() {    
       _image = image; 
       uploadFile();   
     });    
   });    
 }  

 Future uploadFile() async {    
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('avatar/${Path.basename(_image.path)}}');    
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;    
   print('File Uploaded');    
   storageReference.getDownloadURL().then((fileURL) {    
     setState(() {    
       _uploadedFileURL = fileURL;
       _currentImage = _uploadedFileURL;    
     });    
   });    
 }


  @override
  Widget build(BuildContext context) {


    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: widget.uid).userData,
      builder: (contex, snapshot) {
        if(snapshot.hasData){
          if(_uploadedFileURL == null) {
          _currentImage = widget.user.image;
          } else {
            _currentImage = _uploadedFileURL;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text("MODIFICA PROFILO"),
              backgroundColor: Colors.black,
              elevation: 0.0,
                ),
                  key: _formKey,
                  body: SingleChildScrollView(
                  //alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                        SizedBox(height: 10.0),
                        GFAvatar(
                            backgroundImage:
                            NetworkImage(_currentImage),
                        maxRadius: 70.0,
                        shape: GFAvatarShape.circle
                        ),
                        Row(
                          children: <Widget>[
                          Expanded( child: FlatButton(
                                    onPressed: () {
                                      chooseFile();
                                    },
                                  child: new Text("Aggiungi foto"),
                                ),
                          ),
                          Expanded( child: FlatButton (
                                onPressed: () {
                                  camera();
                                },
                          child: new Text("Scatta foto"),
                          
                          ),
                        ),
                          ],
                        ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        initialValue: widget.user.name,
                        decoration: InputDecoration(labelText: "Nome"),
                        onChanged: (val) {
                        setState(() => _currentName = val);
                      }
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        initialValue: widget.user.surname,
                        decoration: InputDecoration(labelText: "Cognome"),
                        onChanged: (val) {
                        setState(() => _currentSurname = val);
                      }
                      ),

                      SizedBox(height: 20.0),
                      TextFormField(
                        readOnly: true,
                        initialValue: widget.user.date,
                        decoration: InputDecoration(labelText: "Data di nascita"),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        readOnly: true,
                        initialValue: widget.user.email,
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      SizedBox(height: 20.0),
                      ButtonTheme(
                        minWidth: 327.0,
                          height: 48.0,
                          child: RaisedButton(
                          color: Colors.black54,
                          child: Text(
                            'Salva',
                            style: TextStyle(color: Colors.white),
                               ),
                               onPressed: () async {
                                      await DatabaseService(uid: widget.user.uid).updateUserData(
                                        _currentName ?? widget.user.name,
                                        _currentSurname ?? widget.user.surname,
                                        _currentEmail ?? widget.user.email,
                                        _currentDate ?? widget.user.date,
                                        _uploadedFileURL ?? widget.user.image,
                                        _currentSponsor ?? widget.user.avaiableSponsor,
                                        null,
                                      );
                                    Navigator.pop(context);
                                },
                              ),
                            ),
                          ]
                        ),
                      )
                    );
                  }
              }
            );

            
    }
}