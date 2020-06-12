import 'package:flutter/material.dart';
import 'package:teamup/screens/home.dart';
import 'package:teamup/screens/myprojects.dart';
import 'package:teamup/screens/nominations.dart';
import 'package:teamup/screens/settings.dart';

import '../screens/create_team.dart';


class DestinationView extends StatefulWidget {
  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {

  int _selectedPage = 0;
  String titleBottom ="";
  final List<String> navButton = ["Home", "Candidature", "Progetti", "Profilo"];
  bool myBool = false;


    final List<Widget>_pageOption = [
      Homepage(),
      Nominations(),
      MyProjectsList(),
      SettingsPage()
    ];

    @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(navButton[_selectedPage]),
        centerTitle: true,
        leading: _selectedPage == 0 ? IconButton(
          iconSize: 30.0,
          color: Colors.white,
          icon: Icon(Icons.filter_list),
          onPressed: () {},
        ) :  Container(),
        actions: <Widget>[
          _selectedPage == 0 ? IconButton(
            iconSize: 30.0,
            color: Colors.white,
            icon: Icon(Icons.create),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTeam()));
            },
          ) :  Container(),
        ]
      ),
                body: _pageOption[_selectedPage],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.yellowAccent,
                  unselectedItemColor: Colors.white,
                  currentIndex: _selectedPage,
                  onTap: (int index) {
                    setState(() {
                      _selectedPage = index;
                      titleBottom = navButton[_selectedPage];
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text(navButton[0])
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        title: Text(navButton[1])
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        title: Text(navButton[2])
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        title: Text(navButton[3])
                    ),
                  ],
                ),
              );


       // }




  }
}
