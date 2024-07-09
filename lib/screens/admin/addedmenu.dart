import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddedMenu extends StatefulWidget {
  const AddedMenu({super.key});

  @override
  State<AddedMenu> createState() => _AddedMenuState();
}

class _AddedMenuState extends State<AddedMenu> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              size: 25, color: Colors.indigo),
        ),
        title: Text("Added Menu"),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                          child:
                              Text("Food", style: TextStyle(fontSize: 22.5))),
                      Tab(
                          child:
                              Text("Juice", style: TextStyle(fontSize: 22.5))),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildMenuList('Food'),
                        _buildMenuList('Juice'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade900));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: Colors.white10,
                leading: GestureDetector(
                  onTap: () => _showImagePickerDialog(data.id, collection),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: data['foodpic'] != null
                        ? CachedNetworkImageProvider(data['foodpic'])
                        : AssetImage('assets/placeholder.png') as ImageProvider,
                  ),
                ),
                title: Text(data['name'],
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹${data['price']}',
                        style: TextStyle(color: Colors.white70, fontSize: 18)),
                    Text(data['desc'],
                        style: TextStyle(color: Colors.white70, fontSize: 18)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      value: data['isEnabled'] as bool,
                      onChanged: (bool value) {
                        _toggleItemStatus(data.id, collection, value);
                      },
                    ),
                    SizedBox(width: 2.5),
                    FloatingActionButton.small(
                      onPressed: () {
                        _showEditDialog(data.id, collection, data);
                      },
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                    SizedBox(width: 2.5),
                    FloatingActionButton.small(
                      onPressed: () {
                        _showDeleteConfirmationDialog(data.id, collection);
                      },
                      backgroundColor: Colors.red.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _toggleItemStatus(
      String docId, String collection, bool isEnabled) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .update({
        'isEnabled': isEnabled,
      });
      setState(() {}); // Refresh the UI if needed
    } catch (e) {
      print('Error updating item status: $e');
    }
  }

  void _showImagePickerDialog(String docId, String collection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text("Menu item image",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Container(
            height: 230,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Select menu item image from:",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery, docId, collection);
                    Navigator.pop(context);
                  },
                  child: Text("Gallery",
                      style: TextStyle(color: Colors.white, fontSize: 17.5)),
                ),
                Divider(),
                TextButton(
                  onPressed: () {
                    pickImage(ImageSource.camera, docId, collection);
                    Navigator.pop(context);
                  },
                  child: Text("Camera",
                      style: TextStyle(color: Colors.white, fontSize: 17.5)),
                ),
                Divider(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 17.5)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickImage(
      ImageSource source, String docId, String collection) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      String filePath = pickedFile.path;
      await _uploadImage(filePath, docId, collection);
    }
  }

  Future<void> _uploadImage(
      String filePath, String docId, String collection) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('menupics')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(File(filePath));

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .update({
        'foodpic': imageUrl,
      });

      setState(() {}); // Refreshes the UI with the updated image
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _updateMenuItem(
      String docId,
      String collection,
      dynamic data,
      TextEditingController nameController,
      TextEditingController priceController,
      TextEditingController descController) async {

    // Get trimmed values from controllers
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final description = descController.text.trim();

    // Check if any of the fields are empty
    if (name.isEmpty || price.isEmpty || description.isEmpty) {
      return; // Exit the method if validation fails
    }

    final newDocId = nameController.text.trim();

    if (newDocId.isNotEmpty && newDocId != data['name']) {
      // Create a new document with the updated name
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(newDocId)
          .set({
        'name': nameController.text,
        'price': priceController.text,
        'desc': descController.text,
        'foodpic': data['foodpic'], // Retain the existing picture
        'isEnabled': data['isEnabled'], // Retain the current status
      });

      // Delete the old document
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Menu item updated successfully", style: TextStyle(color: Colors.white)),
        ),
      );
      Navigator.pop(context);
    } else {
      // Update the existing document if the name hasn't changed
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .update({
        'name': nameController.text,
        'price': priceController.text,
        'desc': descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Menu item updated successfully", style: TextStyle(color: Colors.white)),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showEditDialog(String docId, String collection, dynamic data) {
    final TextEditingController nameController =
        TextEditingController(text: data['name']);
    final TextEditingController priceController =
        TextEditingController(text: data['price'].toString());
    final TextEditingController descController =
        TextEditingController(text: data['desc']);

    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.black87,
            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_outlined,
                      size: 30, color: Colors.indigo),
                ),
                SizedBox(width: 15),
                Text(
                  "Update Menu Item",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1),
                ),
              ],
            ),
            content: Container(
              height: 450,
              width: 500,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("  Name",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.fastfood, color: Colors.orange.shade900),
                        hintText: "Name",
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
                    child: Text("  Price",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: priceController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.money, color: Colors.green.shade900),
                        hintText: "Price",
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
                    child: Text("  Description",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: descController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description,
                            color: Colors.purple.shade900),
                        hintText: "Description",
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
                      onSubmitted: (value) => _updateMenuItem(
                          docId,
                          collection,
                          data,
                          nameController,
                          priceController,
                          descController),
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    height: 65,
                    width: 350,
                    child: ElevatedButton(
                      onPressed: () => _updateMenuItem(docId, collection, data,
                          nameController, priceController, descController),
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String docId, String collection) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title:
              Text("Confirm deletion", style: TextStyle(color: Colors.white)),
          content: Text("Are you sure you want to delete this menu item?",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection(collection)
                    .doc(docId)
                    .delete();
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
