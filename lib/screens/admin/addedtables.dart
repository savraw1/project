import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddedTables extends StatefulWidget {
  const AddedTables({super.key});

  @override
  State<AddedTables> createState() => _AddedTablesState();
}

class _AddedTablesState extends State<AddedTables> {

  Future<void> _showDeleteDialog(String collection, String docId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text('Confirm Deletion',style: TextStyle(
              color: Colors.white)),
          content: Text('Are you sure you want to delete this table?',style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete',style: TextStyle(color: Colors.red)),
              onPressed: () async {
                // Perform the delete operation
                await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined, size: 25, color: Colors.indigo)),
        title: Text("Added tables"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Tables_2seats").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      String docId = document.id;
                      return InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStateProperty.all(Colors.black),
                        onTap: () {
                          _showDeleteDialog('Tables_2seats', docId);
                        },
                        child: Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.15),
                            Container(
                              height: 60,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 60,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.225,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Tables_4seats").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      String docId = document.id;
                      return InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStateProperty.all(Colors.black),
                        onTap: () {
                          _showDeleteDialog('Tables_4seats', docId);
                        },
                        child: Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.12),
                            Column(
                              children: [
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ]),
                                SizedBox(height: 15),
                                Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.225,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Tables_6seats").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      String docId = document.id;
                      return InkWell(
                        splashColor: Colors.black,
                        overlayColor: MaterialStateProperty.all(Colors.black),
                        onTap: () {
                          _showDeleteDialog('Tables_6seats', docId);
                        },
                        child: Row(
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.25),
                            Column(
                              children: [
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ]),
                                SizedBox(height: 15),
                                Container(
                                  height: 140,
                                  width: 220,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(children: [
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 15,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
