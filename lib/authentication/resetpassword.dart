import 'package:flutter/material.dart';
import 'package:teamup/database/auth.dart';
import 'package:teamup/global/constants.dart';

class Resetpassword extends StatefulWidget {

  final Function toggleView;
  Resetpassword({ this.toggleView });

  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {

  final AuthService _auth = AuthService();
  bool loading = false;

  String email = '';
  String error = '';

  @override
  void initState() {
    print("RECUPERA PASS");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Recupera password', textAlign: TextAlign.center),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                    TextFormField(
                    decoration: textInputDecoration.copyWith(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),          //Colore dell'input text
                      validator: (val) => val.isEmpty ? 'Inserisci una email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      }
                    ),
                    SizedBox(height: 20.0),
                    ButtonTheme(
                        minWidth: 327.0,
                        height: 48.0,
                        child: RaisedButton(
                        color: Colors.yellowAccent,
                        child: Text(
                          'Recupera',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed:  () async {
                          setState(() => loading = true);
                          await _auth.resetPassword(email);
                          Navigator.pop(context);
                        }
                      ),
                    ),
                ],
              )
            ),
        ),
      );
    }
}