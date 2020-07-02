import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/report.dart';
import 'package:teamup/screens/profile/project_applications.dart';
import 'package:teamup/screens/project_owner_profile.dart';
import 'package:teamup/widgets/loading.dart';
import 'package:getflutter/getflutter.dart';
import 'package:toast/toast.dart';


class ProjectDetails extends StatefulWidget {

  ProjectDetails({this.title, this.description, this.maxTeammate, this.qualities, this.uid, this.category, this.owner, this.ownerImage, this.name, this.surname, this.cv});
  var title;
  var description;
  var maxTeammate;
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

  Report report = new Report();
  FirebaseUser firebaseUser;
  bool loading = true;
  ProjectData project = new ProjectData();
  static int statoCandidatura = 1;
  String tmpContent;


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
                      children: [
                        Text("Descrizione",textAlign: TextAlign.center,
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
                if(widget.qualities.length == 0)
                  Text("Non sono richieste particolari competenze per questo progetto.",maxLines:2 , textAlign: TextAlign.center,),
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
              onPressed: () {
                customAlertDialog(context);

              },
              child: Text("Segnala",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    } else {
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
                color: Colors.red.shade400,
                onPressed: () {
                  deleteMyProject();
                  //TODO eliminare navBack quando fa la pop
                  Navigator.pop(context);
                },
                child: Text("Elimina Progetto",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
              color: Colors.green.shade900,
              onPressed: () {
                //TODO invece della pop va fatta una push con la nuova pagina e i bundle sponsor 10-20-50 eur
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectApplications()),
                );
              },
              child: Text("Visualizza Candidature",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
              color: Colors.indigo,
              onPressed: () {
                //TODO invece della pop va fatta una push con la nuova pagina e i bundle sponsor 10-20-50 eur
                Navigator.pop(context);
              },
              child: Text("Sponsorizza Progetto",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Questo è un tuo progetto\nnon puoi candidarti.",
                textAlign: TextAlign.center),
          ),
        ],
      );
    }
  }

  Map<String, dynamic> _convertUserToMap()
  {
    Map<String, dynamic> map = {};
    map.putIfAbsent(firebaseUser.uid, () => statoCandidatura);
    return map;
  }

  addApplication() async {
    await DatabaseService().addCandidatura(_convertUserToMap(), widget.uid);
  }

  deleteMyProject() async {
    await DatabaseService().deleteProject(widget.uid);
    Toast.show("Progetto eliminato correttamente.", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  submit() async {
    await addApplication();
    //TODO verificare se il documento esiste già su firebase tramite key della mappa (firebaseUser.uid)
    Toast.show("Candidatura inviata correttamente.", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  void customAlertDialog(BuildContext context){
    Widget cancelButton = FlatButton(
      child: Text("Cancella"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        print("Ok");
        completeReport();
      },
    );
    var dialog = AlertDialog(
      title: Text("SEGNALAZIONE"),
      content: TextField(
        maxLines: null,
        //catturo l'input inserito
        onChanged: (content) {
          setState(() => tmpContent = content);
        },
        decoration: InputDecoration(
          labelText: 'Segnalazione',
          hintText: 'Segnalazione',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      )
      ,
      actions: [
        okButton,
        cancelButton,
      ],
      shape: RoundedRectangleBorder(
          side: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(10)
      ),
      elevation: 10,
      backgroundColor: Colors.white,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  createReport(){
    setState(() {
      report.projectId = widget.uid;
      report.userId = firebaseUser.uid;
      report.content = tmpContent;
      report.projectName=widget.title;
    });
  }

  completeReport() async {
    await createReport();
    DatabaseService().addReport(report);
    print("AGGIUNTO");
    Navigator.pop(context);
    Toast.show("Segnalazione inviata correttamente", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    setState(() {
      tmpContent = "";
    });
  }
}
