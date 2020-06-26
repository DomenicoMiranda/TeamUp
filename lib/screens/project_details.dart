import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/widgets/loading.dart';
import 'package:getflutter/getflutter.dart';


class ProjectDetails extends StatefulWidget {


  ProjectDetails({this.title, this.description, this.qualities, this.uid, this.category, this.owner, this.ownerImage, this.name, this.surname});
  var title;
  var description;
  List<dynamic> qualities;
  var category;
  var uid;
  var owner;
  var ownerImage;
  var name;
  var surname;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {

  FirebaseUser firebaseUser;
  bool loading = true;

  @override
  void initState() {
   getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("DETTAGLI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
                width: MediaQuery.of(context).size.width ,
                child: Text(widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GFAvatar(
                    maxRadius: 50,
                    backgroundImage: NetworkImage(widget.ownerImage),
                    shape: GFAvatarShape.circle,
                  ),
                ),
                Container(
                  child: Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Descrizione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(widget.description, maxLines: 2,),
                      ],
                    ),

                  ),
                ),
              ],
            ),
          Text("Competenze richieste " , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var name in widget.qualities)
                  Text(name, maxLines: 2,),
              ],
            ),

           Card(
             color: Colors.grey,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8.0),
             ),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Ideatore", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                   Text(widget.name+" "+widget.surname)
                 ],
               ),
             ),
           ),

           // Text(widget.owner),
            showButton(),
          ],
        ),
      ),
    );
  }

  getUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.toString());
    print("OWNERID: "+widget.owner);
    print("UID CORRENTE: "+firebaseUser.uid);
    print("IMAGE "+widget.ownerImage.toString());
    setState(() {
      loading = false;
    });
  }

  Widget showButton(){
    if(widget.owner != firebaseUser.uid){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: double.infinity,
              height: 32,
              color: Colors.blue.shade500,
              onPressed: () {},
              child: Text("Candidami!",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: double.infinity,
              height: 32,
              color: Colors.blue.shade500,
              onPressed: () {},
              child: Text("Visualizza profilo",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }else{
      return Text("Questo è un tuo progetto\nnon puoi candidarti.", textAlign: TextAlign.center,);
    }
  }
}
