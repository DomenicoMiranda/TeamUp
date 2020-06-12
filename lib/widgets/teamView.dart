import 'package:flutter/material.dart';

class TeamForms extends StatefulWidget {
  @override
  _TeamFormsState createState() => _TeamFormsState();
}

class _TeamFormsState extends State<TeamForms> {

  String value = "";

  @override
  Widget build(BuildContext context) {
    return TextField(
          //catturo l'input inserito
          onChanged: (text) {
            value = text;
            //lo stampo nella console ogni volta che cambia
            print(value);
          },
          decoration: InputDecoration(
            labelText: 'Nome Team',
            hintText: 'Nome Team',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
              borderSide: BorderSide(color: Colors.blue),
            ),
        ),
    );
  }
}
