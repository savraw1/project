import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/admin/addedtables.dart';

class AddTable extends StatefulWidget {
  const AddTable({super.key});

  @override
  State<AddTable> createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  // Method to add a 2-seater table
  Future<void> _2seats() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check current tables and get the next ID
      final QuerySnapshot snapshot = await firestore.collection("Tables_2seats").get();
      if (snapshot.docs.length >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cannot add more than 2 tables")));
        return;
      }

      // Determine the tableId based on existing documents
      String tableId = snapshot.docs.isEmpty ? "t1" : "t2"; // Using t1 or t2 as document IDs

      // Add the new table with the specified ID
      await firestore.collection("Tables_2seats").doc(tableId).set({}); // Empty document

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("2-seater table added successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit: $e")));
    }
  }

  // Method to add a 4-seater table
  Future<void> _4seats() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check current tables and get the next ID
      final QuerySnapshot snapshot = await firestore.collection("Tables_4seats").get();
      if (snapshot.docs.length >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cannot add more than 2 tables")));
        return;
      }

      // Determine the tableId
      String tableId = snapshot.docs.isEmpty ? "f1" : "f2"; // Using f1 or f2 as document IDs

      // Add the new table with the specified ID
      await firestore.collection("Tables_4seats").doc(tableId).set({}); // Empty document

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("4-seater table added successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit: $e")));
    }
  }

  // Method to add a 6-seater table
  Future<void> _6seats() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check current tables and get the next ID
      final QuerySnapshot snapshot = await firestore.collection("Tables_6seats").get();
      if (snapshot.docs.length >= 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cannot add more than 1 table")));
        return;
      }

      // Determine the tableId
      String tableId = snapshot.docs.isEmpty ? "s1" : "s2"; // Using s1 or s2 as document IDs

      // Add the new table with the specified ID
      await firestore.collection("Tables_6seats").doc(tableId).set({}); // Empty document

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("6-seater table added successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to submit: $e")));
    }
  }

  bool turn1 = true;
  bool turn2 = true;
  bool turn3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, size: 25, color: Colors.indigo),
        ),
        title: Text("Add table"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 35),
                      Text("2 seats", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, letterSpacing: 1)),
                      SizedBox(width: 85),
                      InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: () {
                          turn1 = !turn1;
                          turn2 = true;
                          turn3 = true;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 15,
                              decoration: BoxDecoration(color: turn1 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(color: turn1 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 15,
                              decoration: BoxDecoration(color: turn1 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 35),
                      Text("4 seats", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, letterSpacing: 1)),
                      SizedBox(width: 75),
                      InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: () {
                          turn1 = true;
                          turn2 = !turn2;
                          turn3 = true;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 60,
                                  decoration: BoxDecoration(color: turn2 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  height: 15,
                                  width: 60,
                                  decoration: BoxDecoration(color: turn2 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(color: turn2 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 60,
                                  decoration: BoxDecoration(color: turn2 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  height: 15,
                                  width: 60,
                                  decoration: BoxDecoration(color: turn2 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 35),
                      Text("6 seats", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, letterSpacing: 1)),
                      SizedBox(width: 15),
                      InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStatePropertyAll(Colors.black),
                        onTap: () {
                          turn1 = true;
                          turn2 = true;
                          turn3 = !turn3;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 15,
                                      width: 60,
                                      decoration: BoxDecoration(color: turn3 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                    ),
                                    SizedBox(width: 15),
                                    Container(
                                      height: 15,
                                      width: 60,
                                      decoration: BoxDecoration(color: turn3 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                    ),
                                    SizedBox(width: 15),
                                    Container(
                                      height: 15,
                                      width: 60,
                                      decoration: BoxDecoration(color: turn3 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(
                                  height: 140,
                                  width: 220,
                                  decoration: BoxDecoration(color: turn3 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Container(
                                      height: 15,
                                      width: 60,
                                      decoration: BoxDecoration(color: turn3 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                    ),
                                    SizedBox(width: 15),
                                    Container(
                                      height: 15,
                                      width: 60,
                                      decoration: BoxDecoration(color: turn3 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                    ),
                                    SizedBox(width: 15),
                                    Container(
                                      height: 15,
                                      width: 60,
                                      decoration: BoxDecoration(color: turn3 ? Colors.grey : Colors.indigo, borderRadius: BorderRadius.circular(5)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 65,
                width: 170,
                child: ElevatedButton(
                  onPressed: () {
                    if (turn1 == false) {
                      _2seats();
                    } else if (turn2 == false) {
                      _4seats();
                    } else if (turn3 == false) {
                      _6seats();
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue.shade900),
                  ),
                ),
              ),
              SizedBox(width: 20),
              SizedBox(
                height: 65,
                width: 170,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddedTables()));
                  },
                  child: Text(
                    "Added tables",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.red.shade900),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
