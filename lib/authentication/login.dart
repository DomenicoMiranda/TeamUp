import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
             Padding(
               padding: const EdgeInsets.only(top: 20),
               child: Container(
                 alignment: Alignment.center,
                   child: Text("TEAMUP")),
             ),
            Card(
              child: Container(
                width: 300,
                height: 50,
                child: Row(
                  children: [
                    Text("nome"),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                width: 300,
                height: 50,
                child: Row(
                  children: [
                    Text("Cognome"),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                width: 300,
                height: 50,
                child: Row(
                  children: [
                    Text("email"),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                width: 300,
                height: 50,
                child: Row(
                  children: [
                    Text("Nickname"),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                width: 300,
                height: 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: Container(
                            child: Text("Nome e cognome"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: 20,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),

                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text("descrizione"),
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
