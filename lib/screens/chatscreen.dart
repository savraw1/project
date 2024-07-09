import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final bool isAdmin;
  final String username;

  const ChatScreen({
    required this.chatId,
    required this.isAdmin,
    required this.username,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _username = 'Client';
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  void _fetchUsername() async {
    try {
      // Assuming widget.chatId is actually the client's userId
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.chatId)
          .get();

      setState(() {
        _username = data['username'] ?? 'Client';
      });
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  void _sendMessage() async {
    _focusNode.requestFocus();
    if (_controller.text.isEmpty) return;

    User? user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('Chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': _controller.text,
      'senderId': user.email, // Assuming email is used as identifier
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14),
            child: Icon(Icons.messenger_outline)),
        title: Text(widget.isAdmin ? widget.username : 'Admin'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message['senderId'] == _auth.currentUser?.email;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue.shade800 : Colors.grey[700],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
                            bottomRight: isMe ? Radius.circular(0) : Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(color: Colors.white, fontSize: 17.5),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(50)),
                      hintText: 'Enter your message...',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 17.5),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: EdgeInsets.symmetric(horizontal: 27.5, vertical: 20)
                    ),
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 62.5,
                  width: 62.5,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue.shade900,
                    shape: CircleBorder(),
                    child: Icon(Icons.send, color: Colors.white, size: 25),
                    onPressed: () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}