import 'package:flutter/material.dart';
import 'package:project/screens/user/homedelivery1.dart';
import 'package:project/screens/user/homedelivery2.dart';
import 'package:project/screens/user/homedelivery3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    DocumentSnapshot data = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
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
          return Center(child: CircularProgressIndicator());
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

          return Scaffold(
            body: pages[select],
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 18,
              unselectedFontSize: 18,
              backgroundColor: Colors.black,
              currentIndex: select,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.grey,
              onTap: (value) {
                setState(() {
                  select = value;
                });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart, size: 30), label: "Cart"),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, size: 30), label: "Profile"),
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
