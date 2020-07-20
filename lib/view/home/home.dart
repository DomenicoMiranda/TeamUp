import 'package:flutter/material.dart';
import 'file:///C:/Users/miran/Documents/GitHub/teamup/lib/view/home/cardView.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
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
