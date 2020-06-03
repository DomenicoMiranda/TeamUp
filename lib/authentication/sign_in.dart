import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:teamup/database/auth.dart';
import 'package:teamup/global/constants.dart';
import 'package:teamup/widgets/loading.dart';
 
class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text filed state 
  String email = '';
  String password = '';
  String name = '';
  String surname = '';
  String error = '';
  String nickname = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
              leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.yellowAccent,),
              onPressed: () => Navigator.pop(context),
                ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
             ),
             extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: SafeArea(
          
          child:  Form(
            
          key: _formKey, //Tieni traccia dello stato e ci servirà per convalidare alcuni dati del modulo (validazione)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Nome',
                  prefixIcon: Icon(Icons.chevron_right, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white), 
                validator: (val) => val.isEmpty ? 'Inserisci il tuo nome' : null,
                onChanged: (val) {
                  setState(() => name = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Cognome',
                  prefixIcon: Icon(Icons.chevron_right, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white), 
                validator: (val) => val.isEmpty ? 'Inserisci il tuo cognome' : null,
                onChanged: (val) {
                  setState(() => surname = val);
                }
              ),
                            SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Nickname',
                  prefixIcon: Icon(Icons.chevron_right, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white), 
                validator: (val) => val.isEmpty ? 'Inserisci il tuo cognome' : null,
                onChanged: (val) {
                  setState(() => nickname = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white), 
                validator: (val) => val.isEmpty ? 'Inserisci una email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),  
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.white)
                ),
                style: TextStyle(color: Colors.white),
                validator: (val) => val.length < 6 ? 'La password deve essere superiorire di 6 caratteri' : null,
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
                  color: Colors.yellowAccent,
                  child: Text(
                    'Registrati',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed:  () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email.trim(), password, name.trim(), surname.trim(), nickname.trim());
                    if(result == null){
                      setState(() {
                      error = 'Inserisci una email valida';
                      loading = false;
                      });
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
              SizedBox(height: 12.0),
              Text(
                'Creando un account accetti i nostri Termini di servizio e politica sulla privacy',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
                SizedBox(height: 20,),
                SignInButton(
                Buttons.Facebook,
                text: "Registrati con Facebook",
                onPressed: () {

                },
                ),
                 SignInButton(
                  Buttons.Google,
                  text: "Registrati con Google",
                  onPressed: () {
                  }
              ),
            ],
          ),
        ),
           ),
        
      ),
    );
  }
}
