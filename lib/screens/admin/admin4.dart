import 'package:flutter/material.dart';
import 'package:project/screens/admin/addmenu.dart';
import 'package:project/screens/admin/addtable.dart';

class Admin4 extends StatefulWidget {
  const Admin4({super.key});

  @override
  State<Admin4> createState() => _Admin4State();
}

class _Admin4State extends State<Admin4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.add,size: 25,color: Colors.indigo),
        title: Text("Add Menu / Table"),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
