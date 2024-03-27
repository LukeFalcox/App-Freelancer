// ignore_for_file: file_names, avoid_print

import 'package:app_freelancer/app/pages/home/home_chat/chat/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerUsers(String username,String email, String password) async {
    try {
      await FirebaseAuth.instance.setLanguageCode('en_US');
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'username': username
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

  void registerCard(String title, String desc, String propostMin, String propostMax,
      int selectedDay, int selectedMonth, String email) async {
    try {
      final infocard = <String, dynamic>{
        'title': title,
        'desc': desc,
        "propostMin": propostMin,
        "propostMax": propostMax,
        "selectedDay": selectedDay,
        "selectedMonth": selectedMonth,
        "user": email
      };

      await _firestore.collection('cards').doc().set(infocard);
    } catch (e) {
      print('Error creating card: $e');
    }
  }

Future<List<Map<String, dynamic>>> getData() async {
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('cards').get();

  List<Map<String, dynamic>> cards =
      snapshot.docs.map((doc) => doc.data()).toList();
  return cards;
}


  Future<void> singOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //GET MESSAGES

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
