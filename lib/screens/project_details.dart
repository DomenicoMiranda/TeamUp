import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/authentication/login.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/report.dart';
import 'package:teamup/models/user.dart';
import 'package:teamup/screens/deleteTeammate.dart';
import 'package:teamup/screens/myprojects.dart';
import 'package:teamup/screens/profile/my_project_applications.dart';
import 'package:teamup/screens/project_owner_profile.dart';
import 'package:teamup/screens/sponsor/sponsor.dart';
import 'package:teamup/widgets/destinationView.dart';
import 'package:teamup/widgets/loading.dart';
import 'package:getflutter/getflutter.dart';
import 'package:toast/toast.dart';

class ProjectDetails extends StatefulWidget {
  ProjectDetails(
      {this.title,
      this.sponsor,
      this.description,
      this.maxTeammate,
      this.qualities,
      this.uid,
      this.category,
      this.owner,
      this.ownerImage,
      this.name,
      this.surname,
      this.cv,
      this.teammates});
  final String title;
  final bool sponsor;
  final String description;
  final int maxTeammate;
  final List<dynamic> qualities;
  final List<dynamic> teammates;
  final String category;
  final String uid;
  final String owner;
  final String ownerImage;
  final String name;
  final String surname;
  final String cv;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  Report report = new Report();
  FirebaseUser firebaseUser;
  String uid;
  UserData user = new UserData();
  UserData teammate = new UserData();
  bool loading = true;
  ProjectData project = new ProjectData();
  static int statoCandidatura = 1;
  String tmpContent;
  List<UserData> teamMates = List<UserData>();

  @override
  void initState() {
    print("TEAMMATES: " + widget.teammates.toString());
    //initialCheck();
    getUser();
    print("CV: " + widget.cv.toString());
    super.initState();
    print("UID: " + widget.uid);
    print("MAXTEAMMATE: " + widget.maxTeammate.toString());
    print("lunghezza: " + widget.teammates.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("DETTAGLI"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.title.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GFAvatar(
                      maxRadius: 50,
                      backgroundImage: NetworkImage(widget.ownerImage),
                      shape: GFAvatarShape.circle,
                    ),
                  ),

                  Text(widget.name.toString() + " " + widget.surname.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

                  SizedBox(
                    height: 5,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Descrizione",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(widget.description.toString()),
                        ],
                      ),
                    ),
                  ),

                  Text(
                    "Competenze richieste ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.qualities.length == 0)
                        Text(
                          "Non sono richieste particolari competenze per questo progetto.",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      if (widget.qualities.length > 0)
                        for (var name in widget.qualities)
                          Text(
                            name.toString(),
                            maxLines: 2,
                          ),
                    ],
                  ),

                  checkTeammates(),

                  user.admin == 1 ? showButtonAdmin() :
                  showButton(),
                ],
              ),
            ),
          );
  }

  getUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      getData();
      getTeammates();
      print(firebaseUser.toString());
      print("OWNERID: " + widget.owner.toString());
      //print("UID CORRENTE: " + firebaseUser.uid.toString());
      print("IMAGE " + widget.ownerImage.toString());
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Widget showButton() {
    if (firebaseUser == null) {
      return notLoggedIn();
    } else if (widget.owner != firebaseUser.uid) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.maxTeammate == widget.teammates.length
                ? Text("Questo progetto è al completo")
                : MaterialButton(
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OwnerProfile(
                              name: widget.name,
                              surname: widget.surname,
                              image: widget.ownerImage,
                              uid: widget.owner,
                            )));
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
              child: Text("Segnala", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    } else if (widget.owner == firebaseUser.uid) {
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
                dialogDeleteProject(context);
              },
              child: Text(
                "Elimina Progetto",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
              color: Colors.red.shade400,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteTeammate(
                            teamMates: teamMates, projectId: widget.uid)));
              },
              child: Text(
                "Elimina Teammate",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.maxTeammate == widget.teammates.length
                ? Text(
                    "Questo progetto è al completo\nnon puoi più accettare candidature.")
                : MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minWidth: double.infinity,
                    height: 32,
                    color: Colors.green.shade900,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectApplications(
                                  projectID: widget.uid,
                                )),
                      );
                    },
                    child: Text(
                      "Visualizza Candidature",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Sponsor(
                            projectID: widget.uid,
                          )),
                );
              },
              child: Text(
                "Sponsorizza Progetto",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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

  getData() async {
    uid = firebaseUser.uid;
    user = await DatabaseService().getUserData(uid);
  }

  addApplication() async {
    await DatabaseService().addCandidatura(firebaseUser.uid, user.name,
        user.surname, widget.owner, statoCandidatura, widget.title, widget.uid);
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

  String projectId() {
    return widget.uid;
  }

  void customAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancella"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
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
      ),
      actions: [
        okButton,
        cancelButton,
      ],
      shape: RoundedRectangleBorder(
          side: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      backgroundColor: Colors.white,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  createReport() {
    setState(() {
      report.projectId = widget.uid;
      report.userId = firebaseUser.uid;
      report.content = tmpContent;
      report.projectName = widget.title;
    });
  }

  completeReport() async {
    await createReport();
    DatabaseService().addReport(report);
    print("AGGIUNTO");
    Navigator.pop(context);
    Toast.show("Segnalazione inviata correttamente", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    setState(() {
      tmpContent = "";
    });
  }

  getTeammates() async {
    for (var doc in widget.teammates) {
      teammate = await DatabaseService().getUserData(doc);
      //print("ADMIN " +teammate.admin.toString());
      teamMates.add(teammate);
      print("GET TEAMMATE: " +
          teammate.name.toString() +
          " " +
          teammate.surname.toString());
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  checkTeammates() {
    if (firebaseUser == null) {
      return Text("");
    } else if (widget.owner == firebaseUser.uid) {
      print("LUNGHEZZA TEAMMATES: " + teamMates.length.toString());
      //print(teamMates[1].toString());
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("TEAMMATES",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            for (var user in teamMates)
              Text(user.name.toString() + " " + user.surname.toString())
          ],
        ),
      );
    } else if (widget.owner != firebaseUser.uid) {
      return Text("");
    }
  }

  initialCheck() async {
    await getUser();
    getTeammates();
  }

  void dialogDeleteProject(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Indietro"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = FlatButton(
      child: Text("Si"),
      onPressed: () {
        print("Ok");
        deleteMyProject();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => DestinationView()));
      },
    );
    var dialog = AlertDialog(
      title: Text("ELIMINA PROGETTO"),
      content: Text("Vuoi davvero cancellare questo  progetto?"),
      actions: [
        okButton,
        cancelButton,
      ],
      shape: RoundedRectangleBorder(
          side: BorderSide(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      backgroundColor: Colors.white,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  notLoggedIn() {
    return SingleChildScrollView(
        child: Center(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Per poter accedere alle funzionalità dell'app devi essere registrato",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              )),
        ),
        MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                "Login",
                style: TextStyle(
                    color: Colors.grey.shade200, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )),
      ]),
    ));
  }

  showButtonAdmin() {

      return Column(
        children: <Widget>[
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
                dialogDeleteProject(context);
              },
              child: Text(
                "Elimina Progetto",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OwnerProfile(
                          name: widget.name,
                          surname: widget.surname,
                          image: widget.ownerImage,
                          uid: widget.owner,
                        )));
              },
              child: Text("Visualizza profilo ideatore",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );

  }
}
