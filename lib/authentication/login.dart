// ignore: prefer_double_quotes
import 'package:flutter/material.dart';
// ignore: prefer_double_quotes
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:teamup/authentication/resetpassword.dart';
import 'package:teamup/database/auth.dart';
import 'package:teamup/global/constants.dart';
import 'package:teamup/widgets/destinationView.dart';
import 'package:teamup/widgets/loading.dart';
import 'package:teamup/authentication/sign_in.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {

 final Function toggleView;
  Login({ this.toggleView });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); //Chiave Globale
  bool loading = false;

  // text filed state 
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: SafeArea(
          child:  Form(
          key: _formKey, //Tieni traccia dello stato e ci servirà per convalidare alcuni dati del modulo (validazione)
          child: SingleChildScrollView(
             child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor),
                ),
                style: TextStyle(color: Colors.black),          //Colore dell'input text
                validator: (val) => val.isEmpty ? 'Inserisci una email valida' : null,
                onChanged: (val) {
                  !mailValidator(val) ? Text("Inserisci una email valida") :
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Password',                  
                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),

                ),
                style: TextStyle(color: Colors.black),          //Colore dell'input text
                validator: (val) => val.isEmpty ? 'Inserisci la password' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                }
              ),
              SizedBox(height: 20.0),
              ButtonTheme(
                minWidth: 327.0,
                height: 48.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Accedi',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onPressed:  () async {
                 if(_formKey.currentState.validate()){
                   setState(() => loading = true);
                  dynamic result = await _auth.signinWithEmailAndPassword(email.trim(), password);
                  if(result == null){
                    setState(() {
                    error = 'Utente non trovato';
                    loading = false;});
                  }else{
                    print("logged");
                    Navigator.push(context, MaterialPageRoute(builder:  (context) => DestinationView()));
                  }
                 }
                }
              ),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              //SizedBox(height: 12.0),
              new FlatButton(
                onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => SignIn()));
                },
                  child: new Text('Non hai un account? Registrati',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14.0),
                  )
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Resetpassword())
                  );
                },
                  child: new Text('Password dimenticata?',
                  style: TextStyle(color: Colors.indigo.shade900, fontSize: 14.0),
                  )
              ),
              
              //SizedBox(height: 100.0),

                 SignInButton(
                  Buttons.Google,
                  text: "  Accedi con Google",
                  onPressed: () {
                    _auth.signInWithGoogle();
                  }
              ),
            ],
          ),
          ),
         
        )
        ),
        
        
      ),
    );
  }

  bool mailValidator(String v) {
    bool result;
    EmailValidator.validate(v) ? result = true : false;
    print("IL RISULTATO " + result.toString());
    return result;
  }

}