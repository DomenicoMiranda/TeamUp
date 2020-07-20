import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:teamup/controller/applicationController.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/user.dart';
import 'package:teamup/view/profile/my_project_applications.dart';
import 'package:teamup/widgets/loading.dart';
import 'file:///C:/Users/miran/Documents/GitHub/teamup/lib/view/profile/pdf_screen.dart';
import 'package:toast/toast.dart';

class ApplicationUserProfile extends StatefulWidget {

  ApplicationUserProfile({this.uid,this.projectId, this.applicationID});

  final String uid;
  final String projectId;
  final String applicationID;


  @override
  _ApplicationUserProfileState createState() => _ApplicationUserProfileState();
}

class _ApplicationUserProfileState extends State<ApplicationUserProfile> {

  bool loading = true;
  UserData user;
  ProjectData project;


  @override
  // ignore: must_call_super
  void initState() {

    getUser();
    getProject();
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
                    backgroundImage: NetworkImage(user.image),
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
                                    Text(user.name,
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
                                    Text(user.surname,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                checkPDF(),
                Column(
                  children: [
                    MaterialButton(child: Text("Accetta"), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green.shade500)),
                      onPressed: () {
                      print(project.teammate.toList());
                      acceptApplication();
                      Toast.show("Utente aggiunto ai teammates", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      project.maxTeammate == project.teammate.length ? ProjectData().fullProject(widget.projectId) : null;
                      Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => ProjectApplications(projectID: widget.projectId))
                      );

                      },
                    ),
                    MaterialButton(child: Text("Rifiuta"), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red.shade500)),
                      onPressed: () {
                        refuseApplication();
                        Toast.show("Candidatura rifiutata", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => ProjectApplications(projectID: widget.projectId,))
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  getProject() async {
    project = await ProjectData().getProjectData(widget.projectId);
  }

  acceptApplication() async {
    await ApplicationController().acceptCandidatura(widget.uid, widget.projectId, project.teammate);
    ApplicationController().updateStatoCandidatura(widget.uid, widget.projectId, widget.applicationID);
  }

  refuseApplication() async {
    await ApplicationController().refuseCandidatura(widget.applicationID);
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
        child: Text("Visualizza CV"),
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
    user = await UserData().getUserData(widget.uid);
    setState(() {
      loading = false;
    });
  }
}
