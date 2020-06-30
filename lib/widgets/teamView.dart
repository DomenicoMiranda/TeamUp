import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/project.dart';
import 'package:teamup/models/user.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'destinationView.dart';
import 'loading.dart';


class TeamForms extends StatefulWidget {
  @override
  _TeamFormsState createState() => _TeamFormsState();
}

class _TeamFormsState extends State<TeamForms> {

  FirebaseUser firebaseUser;
  UserData user;


  final controller = TextEditingController();

  String dropdownValue = "Tutte";
  String tmpCategory;
  String _description;

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
          Form(
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Inserisci una descrizione';
                    }
                    return null;
                  },
                  maxLines: null,
                  //catturo l'input inserito
                  onChanged: (value) {
                     setState(() {
                       project.description = value;
                       print(_description);
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
          SizedBox(height: 20,),

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
          SizedBox(height: 20,),

          //CATEGORIA PROGETTO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width/3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
                child: Center(child: Text("Categoria",style: TextStyle(color: Colors.black54),)),
              ),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
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
                    print(dropdownValue);
                  });
                },
                items: <String> ['Tutte', 'Musica', 'Arte', 'Sport', 'Cinema', 'Business' ]
                    .map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),
          SizedBox(height: 20,),

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

          //BOTTONE PER AGGIUNGERE COMPETENZA
          MaterialButton(
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

          //BOTTONE SUBMIT PROGETTO
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minWidth: double.infinity,
            height: 42,
            color: Colors.blue.shade500,
            onPressed: () {
              if (_formKey.currentState.validate()){
                submit();
              }
            },
            child: Text("CREA PROGETTO",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  addProject() async {
    await DatabaseService().addProject(project);
    print(project.toMap());
  }

  getUser()async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.toString());
//    setState(() {
//      loading = false;
//    });

  }

  getData() async {
    user = await DatabaseService().getUserData(firebaseUser.uid);
    print(user.nickname);
    if(mounted){
      setState(() {
        loading = false;
      });}
  }

  saveToProject()  {
    project.ownerId = firebaseUser.uid;
    project.status = "0";
    project.category = dropdownValue;
    project.ownerImage = user.image;
    project.ownerName = user.name;
    project.ownerSurname = user.surname;
    print(project.toMap());
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
