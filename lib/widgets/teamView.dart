import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teamup/models/project.dart';


class TeamForms extends StatefulWidget {
  @override
  _TeamFormsState createState() => _TeamFormsState();
}

class _TeamFormsState extends State<TeamForms> {
// text field state
  String name = '';
  String description = '';
  int numTeam = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
              //catturo l'input inserito
              onChanged: (text) {
                setState(() => name = text);
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
        TextField(
          //catturo l'input inserito
          onChanged: (text) {
            setState(() => description = text);
          },
          decoration: InputDecoration(
            //TODO: Far andare a capo quando raggiunge il limite
            labelText: 'Descrizione progetto',
            hintText: 'Descrizione progetto',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        SizedBox(height: 20,),
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          onChanged: (num) {
            setState(() => numTeam = num as int);
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
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minWidth: double.infinity,
          height: 42,
          color: Colors.blue.shade500,
          onPressed: () {
            //TODO inserire funzione che aggiunge progetto a firebase
          },
          child: Text("CREA PROGETTO",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
