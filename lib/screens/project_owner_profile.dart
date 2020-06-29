import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/user.dart';
import 'package:teamup/widgets/loading.dart';
import 'package:teamup/widgets/pdf_screen.dart';

class OwnerProfile extends StatefulWidget {
  OwnerProfile({this.name, this.surname, this.image, this.cv, this.email, this.uid});
  final String name;
  final String surname;
  final String image;
  final String cv;
  final String email;
  final String uid;

  @override
  _OwnerProfileState createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {

  UserData user;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("PROFILO"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: new GFAvatar(
                maxRadius: 50,
                backgroundImage: NetworkImage(widget.image),
                shape: GFAvatarShape.circle,
              ),
            ),
            Card(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "DATI",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                          color: Colors.black54,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width - 100,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Nome",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text(widget.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                          color: Colors.black54,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width - 100,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Cognome",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text(widget.surname,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                  child: Column(
                children: [],
              )),
            ),
            checkPDF(),
          ],
        ),
      )),
    );
  }

  checkPDF(){
    if(user.cv == null){
      return Container(
        height: 50,
        child: Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Questo utente non ha ancora caricato il curriculum", textAlign: TextAlign.center,),
            ],
          ),
        ),
      );
    }else{
      return RaisedButton(
        child: Text("Open PDF"),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(cv: user.cv),
          ),
        ),
      );
  }
  }

  getUser()async{
    user = await DatabaseService().getUserData(widget.uid);
    setState(() {
      loading = false;
    });
  }
}
