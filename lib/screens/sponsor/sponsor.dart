import 'package:flutter/material.dart';
import 'package:teamup/database/databaseservice.dart';
import 'package:teamup/models/project.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/models/user.dart';

class Sponsor extends StatefulWidget {
  final String projectID;

  const Sponsor({Key key, this.projectID}) : super(key: key);

  @override
  _SponsorState createState() => _SponsorState();
}

class _SponsorState extends State<Sponsor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sponsorizza Progetto'),
      centerTitle: true,),
      body: Container(
        child: Column(
          children: <Widget>[
            SponsorWidget(context),
          ],
        )
      )
    );
  }


  FirebaseUser firebaseUser;
  String uid;
  UserData user = new UserData();
  bool loading = true;
  ProjectData project = new ProjectData();

  SignedSponsor _bundle = SignedSponsor.five;

  @override
  void initState() {
    print(widget.projectID);
    getUser();
    super.initState();
  }

  getUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    await getData();
    setState(() {
      loading = false;
    });
  }

  getData() async {
    uid = firebaseUser.uid;
    user = await DatabaseService().getUserData(uid);

  }

  @override
  Widget SponsorWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 15.0),
          child: Text("Numero Sponsorizzazioni disponibili: " + user.avaiableSponsor.toString()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minWidth: double.infinity,
            height: 40,
            color: Colors.indigo,
            onPressed: () {
              DatabaseService().setSponsored(firebaseUser.uid, user.avaiableSponsor, widget.projectID);
              Navigator.pop(
                  context,
                  Toast.show("Progetto sponsorizzato con successo.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM)
              );
            },
            child: Text("Sponsorizza!",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8.0, top: 15.0, end: 8.0, bottom: 15.0),
          child: Text('o\nAcquista un bundle promozionale e sponsorizza il tuo progetto', textAlign: TextAlign.center,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100.0,
            //margin: new EdgeInsets.only(right: 46.0),
            decoration: new BoxDecoration(
              //color: Colors.blueGrey.shade200,
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: new Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RadioListTile<SignedSponsor>(
                title: const Text('2 Sponsorizzazioni'),
                subtitle: const Text('5 €'),
                activeColor: Colors.indigo.shade900,
                value: SignedSponsor.five,
                groupValue: _bundle,
                onChanged: (SignedSponsor value) {
                  setState(() {
                    _bundle = value;
                  });
                },
                secondary: const Text('PRO', textAlign: TextAlign.end, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 22)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100.0,
            //margin: new EdgeInsets.only(right: 46.0),
            decoration: new BoxDecoration(
              //color: Colors.blueGrey.shade200,
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: new Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RadioListTile<SignedSponsor>(
                title: const Text('5 Sponsorizzazioni'),
                subtitle: const Text('10 €'),
                activeColor: Colors.indigo.shade900,
                value: SignedSponsor.ten,
                groupValue: _bundle,
                onChanged: (SignedSponsor value) {
                  setState(() {
                    _bundle = value;
                  });
                },
                secondary: const Text('PRO', textAlign: TextAlign.end, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 22)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minWidth: double.infinity,
            height: 40,
            color: Colors.indigo,
            onPressed: () {
              DatabaseService().addBundlePromoToUser(firebaseUser.uid, _bundle);
              Navigator.pop(
                context,
                  Toast.show("Bundle Promo acquistato con successo.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM)
              );
            },
            child: Text("Acquista ora",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        ),
      ],
    );
  }

}

enum SignedSponsor { five , ten }

