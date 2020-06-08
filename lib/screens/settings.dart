import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:
      AppBar(
        title: Text("Profilo"),
        centerTitle: true,
      ),
      body: wrapper()
      );
  }

wrapper(){
      

  if(FirebaseAuth.instance.currentUser() != null){
    print("Logged");
    return loggedIn();
  }else
  print("not logged");
  return notLoggedIn();

}

notLoggedIn(){

    return SingleChildScrollView(
      child:
      Center(
        child: Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width/2,
              child:
                Text("Per poter accedere alle funzionalità dell'app devi essere registrato",overflow: TextOverflow.visible, textAlign: TextAlign.center,)
            ),
            RaisedButton(
              onPressed: null, 
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width/2,
                child: Text("LOGIN"),))
          ]
        ),
      )

    );
}

loggedIn(){


}
  
}