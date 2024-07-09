import 'package:flutter/material.dart';
import 'package:project/screens/admin/addmenu.dart';
import 'package:project/screens/admin/addtable.dart';

class Admin3 extends StatefulWidget {
  const Admin3({super.key});

  @override
  State<Admin3> createState() => _Admin3State();
}

class _Admin3State extends State<Admin3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 300),
            SizedBox(
                height: 65,
                width: 350,
                child: ElevatedButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddMenu()));
                  },
                  child: Text(
                    "Add Menu",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTable()));
                  },
                  child: Text(
                    "Add Table",
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
