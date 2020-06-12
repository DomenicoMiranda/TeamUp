import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeamForms extends StatefulWidget {
  @override
  _TeamFormsState createState() => _TeamFormsState();
}

class _TeamFormsState extends State<TeamForms> {

  String value = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
              //catturo l'input inserito
              onChanged: (text) {
                value = text;
                //lo stampo nella console ogni volta che cambia

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
            value = text;
            //lo stampo nella console ogni volta che cambia

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
          //catturo l'input inserito
          onChanged: (text) {
            value = text;
            //lo stampo nella console ogni volta che cambia
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

      ],
    );
  }
}
