import 'package:flutter/material.dart';
import 'package:teamup/screens/home.dart';
import 'package:teamup/screens/myprojects.dart';
import 'package:teamup/screens/applications.dart';
import 'package:teamup/screens/settings.dart';


class DestinationView extends StatefulWidget {
  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {

  int _selectedPage = 0;

  final List<Widget>_pageOption = [
    Homepage(),
    Applications(),
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
        backgroundColor: Colors.white70,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.shade700,
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
              title: Text('Miei Progetti')
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
