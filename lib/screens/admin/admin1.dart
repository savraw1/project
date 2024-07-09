import 'package:flutter/material.dart';

class Admin1 extends StatefulWidget {
  const Admin1({super.key});

  @override
  State<Admin1> createState() => _Admin1State();
}

class _Admin1State extends State<Admin1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Text("Registered users",
                style: TextStyle(color: Colors.white, fontSize: 25)),
            Spacer(),
            TextButton(onPressed: (){

            },
                child: Text("Log out"))
          ],
        ),
      ),
    );
  }
}
