import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screens/chatscreen.dart';

class Admin3 extends StatefulWidget {
  const Admin3({Key? key}) : super(key: key);

  @override
  State<Admin3> createState() => _Admin3State();
}

class _Admin3State extends State<Admin3> {
  final String adminEmail = 'admin@gmail.com'; // Replace with actual admin email or unique identifier

  Future<String> _getUsername(String userId) async {
    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return userDoc.data()?['username'] ?? 'Unknown User';
  }

  void _deleteChatMessages(String chatId) async {
    // Only delete the messages within the chat, but not the chat document itself.
    var messages = await FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .get();

    for (var message in messages.docs) {
      await message.reference.delete();
    }

    // Optionally, update the UI with a SnackBar to confirm deletion.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat deleted successfully')),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String chatId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            'Confirm Deletion',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete all messages in this chat?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteChatMessages(chatId);
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
        leading: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14),
            child: Icon(Icons.messenger_outline, size: 25, color: Colors.indigo)),
        title: Text("Messages"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error loading users",
                    style: TextStyle(color: Colors.white)));
          }

          var userDocs = snapshot.data!.docs;

          // Filter out the admin by email
          var nonAdminUsers = userDocs.where((user) => user['email'] != adminEmail).toList();

          if (nonAdminUsers.isEmpty) {
            return Center(
                child: Text("No users available",
                    style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: nonAdminUsers.length,
            itemBuilder: (context, index) {
              var userDoc = nonAdminUsers[index];
              var userId = userDoc.id;

              return FutureBuilder<String>(
                future: _getUsername(userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white10),
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            'Loading...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }

                  String chatId = 'admin_$userId'; // Define chatId format here

                  return Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Container(
                      height: 75,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white10),
                      alignment: Alignment.center,
                      child: ListTile(
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          '${snapshot.data}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, chatId);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatId: chatId,
                                isAdmin: true,
                                username: snapshot.data!,  // Pass the client's username here
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
