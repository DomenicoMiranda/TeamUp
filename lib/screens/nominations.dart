import 'package:flutter/material.dart';

class Nominations extends StatefulWidget {
  @override
  NominationsState createState() => NominationsState();
}

class NominationsState extends State<Nominations> {

  int selectedIndex = 0;
  final List<String> categories = [
    "IN CORSO",
    "COMPLETATO",
    "SCADUTO",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mie Candidature"),
            centerTitle: true),
        body: Container (
            height: 50.0,
            //setto lo stesso colore dell'app principale --> primary color
            color: Theme
                .of(context)
                .primaryColor,
            //visualizzo la lista di categories
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  //metodo per prendere l'onTap sulle categories
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0),
                      child: Text(categories[index], style: TextStyle(
                          color: index == selectedIndex ? Colors.white : Colors
                              .white60,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                    ),
                  );
                })
        ));
  }

}