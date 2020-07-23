import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:teamup/controller/profileController.dart';
import 'package:teamup/global/constants.dart';
import 'package:teamup/widgets/destinationView.dart';
import 'package:teamup/widgets/loading.dart';
import 'package:intl/intl.dart';
 
class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final ProfileController _profileController = ProfileController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  DateFormat dateFormat = DateFormat("dd-MM-yyyy – kk:mm");

  // text filed state 
  String email = '';
  String password = '';
  String name = '';
  String surname = '';
  String error = '';
  String nickname = '';
  String date= '';
  int sponsor = 0;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
              backgroundColor: Colors.blue.shade700,
              centerTitle: true,
              title: Text("Registrazione"),
              leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Theme.of(context).accentColor,),
              onPressed: () => Navigator.pop(context),
                ),
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
                  prefixIcon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                ),
                style: TextStyle(color: Colors.black),
                validator: (val) => val.isEmpty ? 'Inserisci il tuo nome' : null,
                onChanged: (val) {
                  setState(() => name = val);
                }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Cognome',
                  prefixIcon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
                ),
                style: TextStyle(color: Colors.black),
                validator: (val) => val.isEmpty ? 'Inserisci il tuo cognome' : null,
                onChanged: (val) {
                  setState(() => surname = val);
                }
              ),


              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.calendar_today, color: Theme.of(context).primaryColor,),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2021),
                        ).then((value) {
                          setState(() {
                            date =  DateFormat("d/MM/y").format(value);
                          });
                        });
                      },
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text("Data di nascita", style: TextStyle(color: Colors.black),),
                          )),
                    ),
                    Text(date, style: TextStyle(color: Theme.of(context).primaryColor),),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor),
                ),
                style: TextStyle(color: Theme.of(context).primaryColor),
                validator: (val) => val.isEmpty ? 'Inserisci una email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),  
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor)
                ),
                style: TextStyle(color: Theme.of(context).primaryColor),
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
                  color: Colors.indigo.shade900,
                  child: Text(
                    'Registrati',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed:  () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _profileController.registerWithEmailAndPassword(email.trim(), password, name.trim(), surname.trim(), date.trim(), null, sponsor );
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DestinationView()),
              );
                    print(result.toString());
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
                'Creando un account accetti i nostri Termini di servizio & politica sulla privacy',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
                SizedBox(height: 20,),
                /*SignInButton(
                Buttons.Facebook,
                text: "Registrati con Facebook",
                onPressed: () {

                },
                ),*/
                 SignInButton(
                  Buttons.Google,
                  text: "Registrati con Google",
                  onPressed: () {
                    ProfileController().signInWithGoogle().whenComplete(() {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return DestinationView();
                          },
                        ),
                      );
                    });
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
