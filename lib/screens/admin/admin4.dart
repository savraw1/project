import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Admin4 extends StatefulWidget {
  final String documentId;
  final String username;
  final String phone;

  const Admin4({
    super.key,
    required this.documentId,
    required this.username,
    required this.phone,
  });

  @override
  State<Admin4> createState() => _Admin4State();
}

class _Admin4State extends State<Admin4> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _phoneController = TextEditingController(text: widget.phone);
    _getCurrentUser();
  }

  File? _image;
  final picker = ImagePicker();
  User? _currentUser;
  String _username = "";
  String _phone = "";

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  void delete() {
    setState(() {
      _image = null;
    });
  }

  @override
  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
    if (user != null) {
      _fetchUserData(user.uid);
    }
  }

  Future<void> _fetchUserData(String uid) async {
    final DocumentSnapshot data =
    await FirebaseFirestore.instance.collection("Users").doc(uid).get();
    if (data.exists) {
      setState(() {
        _username = data['username'];
        _phone = data['phone'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile",
            style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            InkWell(
              borderRadius: BorderRadius.circular(65),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.black,
                        title: Text("Profile picture",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        content: Container(
                          height: 300,
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Select your profile image from:",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20))),
                              SizedBox(height: 25),
                              TextButton(
                                  onPressed: () {
                                    pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Gallery",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.5))),
                              Divider(),
                              TextButton(
                                  onPressed: () {
                                    pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Camera",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.5))),
                              Divider(),
                              TextButton(
                                  onPressed: () {
                                    delete();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Remove",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.5))),
                              Divider(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 17.5))),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: CircleAvatar(
                radius: 65,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.person, size: 50) : null,
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              height: 50,
              width: 175,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade900,
                          title: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    size: 30,
                                    color: Colors.indigo,
                                  )),
                              SizedBox(width: 15),
                              Text("Update user info",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          content: Container(
                            height: 325,
                            width: 500,
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("  Username",style: TextStyle(color: Colors.white,fontSize: 20,letterSpacing: 1))),
                                SizedBox(height: 5),
                                SizedBox(
                                  width: 350,
                                  child: TextField(
                                    controller: _usernameController,
                                    style: TextStyle(color: Colors.black, fontSize: 20),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person, color: Colors.purple),
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      fillColor: Colors.white70,
                                      filled: true,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("  Phone",style: TextStyle(color: Colors.white,fontSize: 20,letterSpacing: 1))),
                                SizedBox(height: 5),
                                SizedBox(
                                  width: 350,
                                  child: TextField(
                                    controller: _phoneController,
                                    style: TextStyle(color: Colors.black, fontSize: 20),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone, color: Colors.blue),
                                      hintText: "Phone",
                                      hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      fillColor: Colors.white70,
                                      filled: true,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                SizedBox(
                                  height: 65,
                                  width: 350,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      FirebaseFirestore.instance.collection('Users').doc(widget.documentId).update({
                                        'username' : _usernameController.text,
                                        'phone': _phoneController.text,
                                      }).then((value) {
                                        SnackBar(content: SnackBarAction(label: "Updated successfully", onPressed: () {
                                        },));
                                        Navigator.pop(context);
                                      }).catchError((error) {
                                        print("Failed to update user info: $error");
                                      });
                                    },
                                    child: Text(
                                      "Update",
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
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Text("Edit profile",
                    style: TextStyle(color: Colors.white, fontSize: 17.5)),
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                    backgroundColor:
                    MaterialStatePropertyAll(Colors.blue.shade900)),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Username: $_username",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(height: 5),
                    Text("Email: ${_currentUser?.email}",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(height: 5),
                    Text("Phone: $_phone",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
