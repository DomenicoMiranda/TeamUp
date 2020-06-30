import 'package:flutter/material.dart';

class Applications extends StatefulWidget {
  @override
  ApplicationsState createState() => ApplicationsState();
}

class ApplicationsState extends State<Applications> {

  List<Widget> containerApplications = [
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: DefaultTabController(
        length: 3,
        child: new Scaffold(
            appBar: new AppBar(
              title: const Text('Candidature'),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TabBar(
                        isScrollable: false, tabs: [
                      new Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: new Tab(text: 'IN ATTESA')
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: new Tab(text: 'CONFERMATE'),
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: new Tab(text: 'SCADUTE'),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            /*body: new TabBarView(
                  children: [
                    new ListView(
                      children: list,
                    ),
                    new ListView(
                      children: list,
                    ),
                  ],
                ),*/
            body: TabBarView(
              children: containerApplications,
            )

        ),
      ),
    );
  }

}