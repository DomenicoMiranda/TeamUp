import 'package:flutter/material.dart';
import 'package:teamup/screens/home.dart';
import 'package:teamup/screens/myprojects.dart';
import 'package:teamup/screens/nominations.dart';
import 'package:teamup/screens/settings.dart';


class DestinationView extends StatefulWidget {
  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {

  int _selectedPage = 0;

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
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Candidature')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Progetti')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profilo')
          ),
        ],
      ),
    );


    // }




  }
}
