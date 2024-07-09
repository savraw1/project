import 'package:flutter/material.dart';
import 'package:project/screens/bottom/booktable.dart';
import 'package:project/screens/bottom/homedelivery.dart';

class Home1 extends StatefulWidget {
  const Home1({super.key});

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Hotel Transylvania",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
            SizedBox(height: 35),
            SizedBox(
                height: 65,
                width: 350,
                child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Bot2()));
                  },
                  child: Text(
                    "Home delivery",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)
                  ),
                )),
            SizedBox(height: 25),
            SizedBox(
                height: 65,
                width: 350,
                child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Bot3()));
                  },
                  child: Text(
                    "Book a table",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
