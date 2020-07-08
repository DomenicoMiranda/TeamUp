import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamup/models/user.dart';

class DeleteTeammate extends StatefulWidget {
  DeleteTeammate({this.teamMates});

  final List<UserData> teamMates;
  @override
  _DeleteTeammateState createState() => _DeleteTeammateState();
}

class _DeleteTeammateState extends State<DeleteTeammate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(

        title: const Text('ELIMINA TEAMMATE'),
    centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                        alignment: Alignment.center,
                          child: Text(widget.teamMates[index].name+" "+widget.teamMates[index].surname)),
                    ),
                  );
            }),
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
        widget.teamMates.removeAt(index);
        Navigator.push(context,
            MaterialPageRoute(
                builder: (_) => DeleteTeammate(teamMates: widget.teamMates,)
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
}
