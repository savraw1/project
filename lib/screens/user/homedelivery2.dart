import 'package:flutter/material.dart';

class User2 extends StatefulWidget {
  const User2({super.key});

  @override
  State<User2> createState() => _User2State();
}

class _User2State extends State<User2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 30,color: Colors.indigo,)),
        title: Text("Cart",style: TextStyle(color: Colors.white,fontSize: 25)),
      ),
    );
  }
}
