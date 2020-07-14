import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/widgets/destinationView.dart';

class DeleteTeammate extends StatefulWidget {
  DeleteTeammate({this.teamMates, this.projectId});

  final List<UserData> teamMates;
  final String projectId;
  @override
  _DeleteTeammateState createState() => _DeleteTeammateState();
}

class _DeleteTeammateState extends State<DeleteTeammate> {

  List<String> newListUpdated = [];

@override
  void initState() {
    newList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
        title: const Text('ELIMINA TEAMMATE'), centerTitle: true,

        ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Scegli il teammate da eliminare", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
              Container(
                //margin: new EdgeInsets.only(right: 46.0),
                decoration: new BoxDecoration(
                  //color: Colors.blueGrey.shade200,
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.circular(30.0),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: new Offset(0.0, 0.0),
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height/1.5,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: widget.teamMates.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          dialogDeleteTeammate(context, index);
                          },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                              height: 40.0,
                              //margin: new EdgeInsets.only(right: 46.0),
                              decoration: new BoxDecoration(
                                //color: Colors.blueGrey.shade200,
                                color: Colors.black54,
                                shape: BoxShape.rectangle,
                                borderRadius: new BorderRadius.circular(10.0),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8.0,
                                    offset: new Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                            alignment: Alignment.center,
                              child: Text(widget.teamMates[index].name.toUpperCase() + " " + widget.teamMates[index].surname.toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                        ),
                      );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minWidth: double.infinity,
                  height: 40,
                  color: Colors.red.shade400,
                  onPressed: () {
                    updateTeammateList();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_)=>DestinationView()
                        )
                    );
                  },
                  child: Text("CONFERMA",
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   dialogDeleteTeammate(BuildContext context, int index){
    Widget cancelButton = FlatButton(
      child: Text("Indietro"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget okButton = FlatButton(
      child: Text("Si"),
      onPressed:  () {
        print("Ok");
        newListUpdated.removeAt(index);
        widget.teamMates.removeAt(index);
        print(newListUpdated.toString());
        DatabaseService().noFullProject(widget.projectId);
        Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => DeleteTeammate(teamMates: widget.teamMates,projectId: widget.projectId,)
            )
        );
      },
    );
    var dialog = AlertDialog(
      title: Text("ELIMINA TEAMMATE"),
      content: Text("Vuoi davvero cancellare questo teammate?"),
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

  updateTeammateList()async {

    await Firestore.instance.collection('projects').document(widget.projectId).updateData({
      'teammate':newListUpdated
    });
    print(newListUpdated.toList().toString());
  }

  newList()async {

     widget.teamMates.forEach((element) {
      newListUpdated.add(element.uid);
    });
  }

}
