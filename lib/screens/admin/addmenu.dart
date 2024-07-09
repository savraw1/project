import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/screens/admin/addedmenu.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  bool turn1 = true;
  bool turn2 = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _desc = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  String _foodpic = "";

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
          .child('menupics')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(File(imagePath));

      final imageUrl = await ref.getDownloadURL();

      setState(() {
        _foodpic = imageUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _addMenuItem() async {
    // Check if any of the text fields are empty
    String itemName = _name.text.trim();
    String itemPrice = _price.text.trim();
    String itemDesc = _desc.text.trim();

    if (itemName.isEmpty || itemPrice.isEmpty || itemDesc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    // Check if an image is selected
    if (_foodpic.isEmpty && _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image for the menu item.')),
      );
      return;
    }

    try {
      // Determine which collection to use based on selection
      String collectionName = turn1 ? 'Food' : 'Juice';

      // Check if an item with the same name already exists in the selected collection
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(itemName)
          .get();

      if (docSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An item with this name already exists. Please choose a different name.')),
        );
        return;
      }

      // Add the item with the specified document ID
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(itemName)
          .set({
        'name': itemName,
        'price': itemPrice,
        'desc': itemDesc,
        'foodpic': _foodpic,
        'isEnabled': true
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu item "$itemName" added successfully to $collectionName!')),
      );

      // Clear the input fields and image after successful addition
      _name.clear();
      _price.clear();
      _desc.clear();
      setState(() {
        _image = null;
        _foodpic = "";
      });
    } catch (e) {
      print('Error adding menu item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_outlined,size: 25,color: Colors.indigo)),
        title: Text("Add menu"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    turn1=true;
                    turn2=false;
                    setState(() {});
                  },
                  child: Container(
                    height: 65,
                    width: 165,
                    decoration: BoxDecoration(color: turn1? Colors.blue.shade900:Colors.grey,borderRadius: BorderRadius.circular(10)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Food",style: TextStyle(color: turn1? Colors.white:Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
                  ),
                ),
                SizedBox(width: 35),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    turn2=true;
                    turn1=false;
                    setState(() {});
                  },
                  child: Container(
                    height: 65,
                    width: 165,
                    decoration: BoxDecoration(color: turn2? Colors.blue.shade900:Colors.grey,borderRadius: BorderRadius.circular(10)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Juice",style: TextStyle(color: turn2? Colors.white:Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
                  ),
                )
              ],
            ),
            SizedBox(height: 35),
            InkWell(
              borderRadius: BorderRadius.circular(65),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.black87,
                        title: Text("Menu item image",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        content: Container(
                          height: 230,
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Select menu item image from:",
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
                    : (_foodpic.isNotEmpty ? CachedNetworkImageProvider(_foodpic) : null) as ImageProvider?,
                child: _image == null && _foodpic.isEmpty ? Icon(Icons.fastfood, size: 50, color: Colors.white70) : null,
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("       Name",style: TextStyle(color: Colors.white,fontSize: 22.5))),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.875,
              child: TextField(
                controller: _name,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
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
            SizedBox(height: 25),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("       Price",style: TextStyle(color: Colors.white,fontSize: 22.5))),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.875,
              child: TextField(
                controller: _price,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
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
            SizedBox(height: 25),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("       Description",style: TextStyle(color: Colors.white,fontSize: 22.5))),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.875,
              child: TextField(
                controller: _desc,
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
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
                onSubmitted: (value) => _addMenuItem(),
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 65,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: () {
                      _addMenuItem();
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddedMenu()));
                    },
                    child: Text(
                      "Added menu",
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
      ),
    );
  }
}