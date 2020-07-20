import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:teamup/controller/projectController.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/user.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/destinationView.dart';
import '../../widgets/loading.dart';


class TeamForms extends StatefulWidget {
  @override
  _TeamFormsState createState() => _TeamFormsState();
}

class _TeamFormsState extends State<TeamForms> {

  FirebaseUser firebaseUser;
  UserData user;
  String uid;


  final controller = TextEditingController();

  String dropdownValue = "Musica";
  String tmpCategory;

  final _formKey = GlobalKey<FormState>();

  ProjectData project = new ProjectData();
// text field state
  int numTeam = 0;
  String tmpQuality;
  List<String> qualities = [];
  bool loading = true;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  loading ? Loading() :SingleChildScrollView(
      child: Column(
        children: [
          //FORM PER NOME E DESCRIZIONE
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //NOME PROGETTO
                  TextFormField(
                    validator: ( value) {
                      if (value.isEmpty) {
                        return 'Inserisci un nome';
                      }
                      return null;
                    },
                    maxLines: null,
                    //catturo l'input inserito
                    onChanged: (text) {
                      setState(() {
                        project.name = text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome Progetto',
                      hintText: 'Nome Progetto',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),

                  //DESCRIZIONE PROGETTO
                  TextFormField(
                    validator: ( value) {
                      if (value.isEmpty) {
                        return 'Inserisci una descrizione';
                      }
                      return null;
                    },
                    maxLines: null,
                    //catturo l'input inserito
                    onChanged: (text) {
                       setState(() {
                         project.description = text;
                         //print("descrizione: "+_description);
                       });
                    },
                    decoration: InputDecoration(
                      labelText: 'Descrizione progetto',
                      hintText: 'Descrizione progetto',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
          SizedBox(height: 15,),

          //NUMERO MASSIMO TEAMMATE
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            onChanged: (num) {
              setState(() => project.maxTeammate = int.parse(num)  );
            },
            decoration: InputDecoration(
              labelText: 'Numero teammates',
              hintText: 'Numero teammates',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 15,),

          //CATEGORIA PROGETTO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                  ),
                  child: Center(child: Text("Categoria",style: TextStyle(color: Colors.black54),)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  elevation: 16,
                  style : TextStyle(
                    color: Colors.black54
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;

                    });
                  },
                  items: <String> [ 'Musica', 'Arte', 'Sport', 'Cinema', 'Business' ]
                      .map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          SizedBox(height: 15,),

          //COMPETENZE
          TextField(
            controller: controller,
            maxLines: null,
            //catturo l'input inserito
            onChanged: (quality) {
              setState(() => tmpQuality = quality);
            },
            decoration: InputDecoration(
              labelText: 'Competenze',
              hintText: 'Competenze',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),

          SizedBox(height: 5),

          //BOTTONE PER AGGIUNGERE COMPETENZA
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: double.infinity,
              height: 42,
              color: Colors.blue.shade500,
              onPressed: () {
                project.qualities.add(tmpQuality);
                controller.clear();
                Toast.show("Competenza aggiunta", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
              },
              child: Text("AGGIUNGI COMPETENZA",
                  style: TextStyle(color: Colors.white)),
            ),
          ),

          SizedBox(height: 20),

          //BOTTONE SUBMIT PROGETTO
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minWidth: double.infinity,
            height: 42,
            color: Colors.indigo.shade900,
            onPressed: () {
              if (_formKey.currentState.validate()){
                submit();
              }
            },
            child: Text("CREA PROGETTO",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  addProject() async {
    await ProjectController().addProject(project);
    print(project.toMap());
  }

  getUser()async {
    uid = await UserData().getUser(uid);
    print("UID "+uid.toString());
//    setState(() {
//      loading = false;
//    });

  }

  getData() async {
    user = await UserData().getUserData(uid);
    if(mounted){
      setState(() {
        loading = false;
      });}
  }

  saveToProject()  {
    project.ownerId = uid;
    project.status = "0";
    project.category = dropdownValue;
    project.ownerImage = user.image;
    project.ownerName = user.name;
    project.ownerSurname = user.surname;
    project.sponsor = false;
    print( "PROGETTO: "+ project.toMap().toString());
  }

  getUserData() async {
    await getUser();
    getData();
  }

  submit() async {
    await saveToProject();
    print(project.toMap());
    await addProject();
    Toast.show("Progetto salvato correttamente", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DestinationView()));
  }
}
