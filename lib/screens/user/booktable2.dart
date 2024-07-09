import 'package:flutter/material.dart';

class User5 extends StatefulWidget {
  const User5({super.key});

  @override
  State<User5> createState() => _User5State();
}

class _User5State extends State<User5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined,
                size: 30, color: Colors.black)),
        title: Text("Message",
            style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
    );
  }
}
