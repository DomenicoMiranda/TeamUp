import 'package:flutter/material.dart';
import 'package:teamup/widgets/cardView.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
                  child: CardView(),
    );
  }
}