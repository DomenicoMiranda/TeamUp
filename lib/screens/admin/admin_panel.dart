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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minWidth: double.infinity,
                  height: 50,
                  color: Colors.red.shade500,
                  child: Text("SEGNALAZIONI", style: TextStyle(color: Colors.white)),
                  onPressed: () {

                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (_) => AdminReports()
                        )
                      );
                  }
              )
            ],
          ),
        )
      ),
    );
  }
}
