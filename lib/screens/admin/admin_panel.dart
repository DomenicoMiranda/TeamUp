import 'package:flutter/material.dart';
import 'package:teamup/screens/admin/admin_reports.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RaisedButton(
                child: Text("SEGNALAZIONI"),
                onPressed: () {

                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => AdminReports()
                      )
                    );
                }
            )
          ],
        )
      ),
    );
  }
}
