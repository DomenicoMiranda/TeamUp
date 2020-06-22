import 'package:flutter/material.dart';
import 'package:teamup/screens/create_project.dart';
import 'package:teamup/widgets/cardView.dart';
import 'package:teamup/widgets/category_selector.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateProject()),
                );
              },
            ),
          ]
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Container(
                child: CardView(),
                //Text('ciao'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
