import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twistic/main.dart';
import 'package:twistic/models/login.dart';
import 'package:twistic/screens/home_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

late SharedPreferences _sharedPreferences;
String _connexionLog = '';

get connexionLog {
  return _connexionLog;
}

setUsersCredentials(String? email, String? pseudo, String? photoUrl) async {
  _sharedPreferences = await SharedPreferences.getInstance();
  _sharedPreferences.setString('email', email.toString());
  _sharedPreferences.setString('pseudo', pseudo.toString());
  _sharedPreferences.setString('photoUrl', photoUrl.toString());
}

login(String email, String password, BuildContext context) async {
  _connexionLog = '';
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    _connexionLog = 'User connected.';
    print(userCredential.user!.email);
    setUsersCredentials(userCredential.user!.email, userCredential.user!.displayName, userCredential.user!.photoURL);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const HomeSreen(title: 'Twistic')));

  } on FirebaseAuthException catch (e) {
    print('code ' + e.code.toString());
    if (e.code == 'user-not-found') {
      _connexionLog = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      _connexionLog = 'Wrong password provided for that email.';
    } else if (e.code == 'invalid-email') {
  _connexionLog = 'Invalid email.';
  } else {
      _connexionLog = 'Erreur du serveur.';
    }

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(connexionLog),
      backgroundColor: Colors.blue.shade900,
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar);

  } catch (e) {
    _connexionLog = 'Error 505';
    print(e);
  }
}

void register(Login login) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: login.email, password: login.password);
  userCredential.user!.updateDisplayName(login.pseudo);
  userCredential.user!.updatePhotoURL(login.urlPhoto);
    print(userCredential);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

void logoutApp() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  _sharedPreferences.clear();
  await FirebaseAuth.instance.signOut();
}

Stream<User?> get user {
  return _auth.authStateChanges();
}
