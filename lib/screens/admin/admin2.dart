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
      appBar: AppBar(
        leading: Icon(Icons.supervised_user_circle,
            size: 25, color: Colors.indigo),
        title: Text("Registered users"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade900),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.925,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10)),
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
                          Text("Phone: ${data["phone"]}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18)),
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
                                        backgroundColor: Colors.black87,
                                        title: Text("Confirm delete?",
                                            style: TextStyle(
                                                color: Colors.white)),
                                        content: Text(
                                            "Are you sure you want to delete this user?",
                                            style: TextStyle(
                                                color: Colors.white)),
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
                                                  content:
                                                      Text("User deleted"),
                                                  action: SnackBarAction(
                                                    label: "Undo",
                                                    onPressed: () {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection("Users")
                                                          .doc(document.id)
                                                          .set(data);
                                                    },
                                                  ),
                                                ));
                                              },
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ))
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
