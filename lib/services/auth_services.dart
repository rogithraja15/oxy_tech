import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oxy_tech/screens/home_page.dart';
import 'package:oxy_tech/screens/login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        try {
          await _firestore.collection('users').doc(user.uid).set({
            'name': name,
            'email': email,
            'uid': user.uid,
          });
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Failed to write data to Firestore.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14,
          );
        }
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with that email.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'User does not exist.';
          break;
        case 'wrong-password':
          message = 'The password is incorrect.';
          break;
        default:
          message = 'An 2 error occurred. Please try again.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }

  Future<void> logout({required BuildContext context}) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage()));
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An 3 error occurred during logout.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }
}
