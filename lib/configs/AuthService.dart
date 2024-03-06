// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerUsers(String email, String password) async {
    try {
      await FirebaseAuth.instance.setLanguageCode('en_US');
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> login(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // after creating the user, create a new document for the user in
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> singOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
