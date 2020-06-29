import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/screens/project_owner_profile.dart';
import 'package:teamup/widgets/loading.dart';
import 'package:getflutter/getflutter.dart';
import 'package:toast/toast.dart';


class ProjectDetails extends StatefulWidget {

  ProjectDetails({this.title, this.description, this.qualities, this.uid, this.category, this.owner, this.ownerImage, this.name, this.surname, this.cv});
  var title;
  var description;
  List<dynamic> qualities;
  var category;
  var uid;
  var owner;
  var ownerImage;
  var name;
  var surname;
  var cv;


  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {

  FirebaseUser firebaseUser;
  bool loading = true;
  ProjectData project = new ProjectData();
  static int statoCandidatura = 1;

  @override
  void initState() {
    getUser();
    print("CV: " + widget.cv.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("DETTAGLI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text(widget.title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GFAvatar(
                    maxRadius: 50,
                    backgroundImage: NetworkImage(widget.ownerImage),
                    shape: GFAvatarShape.circle,
                  ),
                ),
                Container(
                  child: Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Descrizione",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Text(widget.description, maxLines: 2,),
                      ],
                    ),

                  ),
                ),
              ],
            ),
            Text("Competenze richieste ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var name in widget.qualities)
                  Text(name, maxLines: 2,),
              ],
            ),

            Card(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ideatore", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(widget.name + " " + widget.surname)
                  ],
                ),
              ),
            ),

            // Text(widget.owner),
            showButton(),
          ],
        ),
      ),
    );
  }

  getUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.toString());
    print("OWNERID: " + widget.owner);
    print("UID CORRENTE: " + firebaseUser.uid);
    print("IMAGE " + widget.ownerImage.toString());
    setState(() {
      loading = false;
    });
  }

  Widget showButton() {
    if (widget.owner != firebaseUser.uid) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: double.infinity,
              height: 32,
              color: Colors.blue.shade500,
              onPressed: () {
                submit();
              },
              child: Text("Candidami!",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: double.infinity,
              height: 32,
              color: Colors.blue.shade500,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) =>
                            OwnerProfile(
                              name: widget.name,
                              surname: widget.surname,
                              image: widget.ownerImage,
                              uid: widget.owner,
                            )
                    )
                );
              },
              child: Text("Visualizza profilo ideatore",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: double.infinity,
              height: 32,
              color: Colors.blue.shade500,
              onPressed: () {},
              child: Text("Segnala",
                  style: TextStyle(color: Colors.white)),
            ),
          ),

        ],
      );
    } else {
      return Text("Questo è un tuo progetto\nnon puoi candidarti.",
        textAlign: TextAlign.center,);
    }
  }

  Map<String, dynamic> _convertUserToMap()
  {
    Map<String, dynamic> map = {};
    map[firebaseUser.uid] = statoCandidatura;

    return map;
  }

  addApplication() async {
    await DatabaseService().addCandidatura(_convertUserToMap(), widget.uid);

  }

  submit() async {
    await addApplication();
    //TODO verificare se il documento esiste già su firebase tramite key della mappa (firebaseUser.uid)
    Toast.show("Candidatura inviata correttamente.", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }



}
