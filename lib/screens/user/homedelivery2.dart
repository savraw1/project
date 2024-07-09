import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screens/chatscreen.dart';

class User2 extends StatefulWidget {
  const User2({super.key});

  @override
  State<User2> createState() => _User5State();
}

class _User5State extends State<User2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Please log in", style: TextStyle(color: Colors.white))),
      );
    }

    String chatId = 'admin_${user.email}';

    FirebaseFirestore.instance.collection('Chats').doc(chatId).set({
      'users': [user.email, 'admin']
    }, SetOptions(merge: true));

    return Scaffold(
      body: ChatScreen(chatId: chatId, isAdmin: false, username: '',),
    );
  }
}