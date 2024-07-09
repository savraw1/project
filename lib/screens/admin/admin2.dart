import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Admin2 extends StatefulWidget {
  const Admin2({super.key});

  @override
  State<Admin2> createState() => _Admin2State();
}

class _Admin2State extends State<Admin2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Registered users",
            style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              return Column(
                children: [
                  SizedBox(height: 15),
                  Container(
                    width: 425,
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(data["email"],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username: ${data["username"]}",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18)),
                          Text("Phone: ${data["phone"]}",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext) {
                                      return AlertDialog(
                                        title: Text("Confirm delete?"),
                                        content: Text(
                                            "Are you sure you want to delete this user?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel")),
                                          TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("Users")
                                                    .doc(document.id)
                                                    .delete();
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text("User deleted"),
                                                  action: SnackBarAction(
                                                    label: "Undo",
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection("Users")
                                                          .doc(document.id)
                                                          .set(data);
                                                    },
                                                  ),
                                                ));
                                              },
                                              child: Text("Delete"))
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.delete,
                                  color: Colors.red, size: 30))
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
