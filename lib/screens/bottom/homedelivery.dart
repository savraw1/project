import 'package:flutter/material.dart';
import 'package:project/screens/user/homedelivery1.dart';
import 'package:project/screens/user/homedelivery2.dart';
import 'package:project/screens/user/homedelivery3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user/home.dart';

class Bot2 extends StatefulWidget {
  const Bot2({super.key});

  @override
  State<Bot2> createState() => _Bot2State();
}

class _Bot2State extends State<Bot2> {
  int select = 0;
  late Future<Map<String, String>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<Map<String, String>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }

    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.email)
        .get();
    if (data.exists) {
      return {
        'documentId': user.uid,
        'username': data['username'],
        'phone': data['phone'],
      };
    } else {
      throw Exception("User data does not exist");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade900));
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final pages = [
            User1(),
            User2(),
            User3(
              documentId: data['documentId']!,
              username: data['username']!,
              phone: data['phone']!,
            ),
          ];

          return WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home1()),
                (route) => false,
              );
              return false;
            },
            child: Scaffold(
              body: pages[select],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: select,
                onTap: (value) {
                  setState(() {
                    select = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.14),
                          child: Icon(Icons.messenger_outline)),
                      label: "Message"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Profile"),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }
}
