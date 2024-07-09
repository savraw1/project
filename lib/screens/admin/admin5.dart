import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../login.dart';

class Admin5 extends StatefulWidget {
  final String email;
  final String username;
  final String phone;

  const Admin5({
    super.key,
    required this.email,
    required this.username,
    required this.phone,
  });

  @override
  State<Admin5> createState() => _Admin5State();
}

class _Admin5State extends State<Admin5> {
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
  String _profilepic = "";

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Upload image to Firebase Storage
      await _upload(pickedFile.path);
    } else {
      print("No image selected");
    }
  }

  Future<void> _upload(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profilepics')
          .child('${_currentUser!.email}.jpg');

      await ref.putFile(File(imagePath));

      final imageUrl = await ref.getDownloadURL();

      // Save image URL to Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_currentUser!.email)
          .update({'profilepic': imageUrl});
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> delete() async {
    setState(() {
      _image = null;
      _profilepic = "";
    }
    );
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUser!.email)
        .update({'profilepic': ""});
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
    await FirebaseFirestore.instance.collection("Users").doc(_currentUser!.email).get();
    if (data.exists) {
      setState(() {
        _username = data['username'];
        _phone = data['phone'];
        _profilepic = data['profilepic'] ?? "";
      });
    }
  }

  void _updateUserInfo() {
    // Validate if the username or phone fields are empty
    if (_usernameController.text.isEmpty || _phoneController.text.isEmpty) {
      return; // Exit the method early if validation fails
    }

    // Proceed with updating user info if fields are not empty
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUser!.email)
        .update({
      'username': _usernameController.text,
      'phone': _phoneController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User info updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context); // Close the dialog
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user info: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login1()),
            (route) => false, // This condition will remove all previous routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*1.25,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.person,size: 25,color: Colors.indigo),
            title: Text("Profile"),
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
                            backgroundColor: Colors.black87,
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
                                        _getCurrentUser();
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
                                        _getCurrentUser();
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
                                        _getCurrentUser();
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
                    backgroundColor: Colors.white10,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (_profilepic.isNotEmpty
                        ? CachedNetworkImageProvider(_profilepic, )
                        : null) as ImageProvider?,
                    child: _image == null && _profilepic.isEmpty
                        ? Icon(Icons.person, size: 50, color: Colors.white70)
                        : null,
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
                              backgroundColor: Colors.black87,
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
                                          fontWeight: FontWeight.bold,letterSpacing: 1)),
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
                                        textInputAction: TextInputAction.next,
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
                                        keyboardType: TextInputType.number,
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
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (value) {
                                          _updateUserInfo();
                                          _getCurrentUser();
                                        }
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    SizedBox(
                                      height: 65,
                                      width: 350,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _updateUserInfo();
                                          _getCurrentUser();
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
                        Text("Email: ${_currentUser!.email}",
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(height: 5),
                        Text("Phone: $_phone",
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 45,
                  width: 115,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.red.shade900),
                        shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
                    onPressed: () {
                      signOutUser(context);
                    },
                    child: Text("Log out",
                        style: TextStyle(color: Colors.white, fontSize: 17.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
