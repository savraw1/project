import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/admin/admin1.dart';
import 'package:project/screens/admin/admin2.dart';
import 'package:project/screens/admin/admin3.dart';
import 'package:project/screens/admin/admin4.dart';
import 'package:project/screens/admin/admin5.dart';

class Bot1 extends StatefulWidget {
  const Bot1({super.key});

  @override
  State<Bot1> createState() => _Bot1State();
}

class _Bot1State extends State<Bot1> {
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

    DocumentSnapshot data = await FirebaseFirestore.instance.collection("Users").doc(user.email).get();
    if (data.exists) {
      return {
        'email' : data['email'],
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
          return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final pages = [
            Admin1(),
            Admin2(),
            Admin3(),
            Admin4(),
            Admin5(
              email: data['email']!,
              username: data['username']!,
              phone: data['phone']!,
            )
          ];

          return Scaffold(
            body: pages[select],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: select,
              onTap: (value) {
                setState(() {
                  select = value;
                });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), label: "Users"),
                BottomNavigationBarItem(icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: Icon(Icons.messenger_outline)), label: "Message"),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
              ],
            ),
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }
}