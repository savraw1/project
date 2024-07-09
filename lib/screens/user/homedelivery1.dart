import 'package:flutter/material.dart';

class User1 extends StatefulWidget {
  const User1({super.key});

  @override
  State<User1> createState() => _User1State();
}

class _User1State extends State<User1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 30,color: Colors.indigo)),
        title: Row(
          children: [
            Text("Select a location",style: TextStyle(color: Colors.white,fontSize: 25)),
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
