import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamup/models/teammate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ProfileController {

  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn( scopes: ['email']);


  Future updateUserData(String name, String surname, String email, String date, String image, int admin, int sponsor, String uid) async {

    return await usersCollection.document(uid).setData({
      'admin' : admin,
      'name': name,
      'surname': surname,
      'email' : email,
      'date' : date,
      'image' : image,
    }, merge: true);
  }

  Future updateUserCv(String cv, String uid) async {

    return await usersCollection.document(uid).updateData({'cv': cv});
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }


  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password, String name, String surname, String date, String image, int sponsor) async {

    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await ProfileController().updateUserData(name, surname, email, date, image, 0, sponsor, user.uid);
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString);
      return null;
    }
  }


  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;

    }
  }

  //reset password
  Future<void> resetPassword(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch (e){
      print(e.toString());
      return null;
    }
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }




  //sign in with email & password

  //get current user
  Future<String> currentUser() async {
    try{
      final FirebaseUser user = await _auth.currentUser();
      final userid = user.uid;
      return userid.toString();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn
        .signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    _userFromFirebaseUser(user);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);


    return 'signInWithGoogle succeeded: $user';
  }

  signiInGoogle() async {
    try{
      await googleSignIn.signIn();

    }catch(err){
      print(err);
    }
  }




}
