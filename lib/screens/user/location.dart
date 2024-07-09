import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/screens/user/address.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Stream<List<Map<String, dynamic>>>? addressStream;
  int? selectedIndex;  // Track the selected address
  TextEditingController _flatController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _townController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressStream = _getAddressStream();
    _setInitialSelectedIndex();
  }

  void _setInitialSelectedIndex() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('addresses')) {
          final addresses = List<Map<String, dynamic>>.from(data['addresses']);
          // Find the first address with "selected": true and set selectedIndex
          final initialSelectedIndex =
          addresses.indexWhere((address) => address['selected'] == true);
          setState(() {
            selectedIndex = initialSelectedIndex >= 0 ? initialSelectedIndex : null;
          });
        }
      }
    }
  }

  // Get the stream of addresses from Firestore
  Stream<List<Map<String, dynamic>>> _getAddressStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('addresses')) {
            return List<Map<String, dynamic>>.from(data['addresses']);
          }
        }
        return [];
      });
    } else {
      return Stream.value([]);
    }
  }

  // Function to handle selection of an address
  void _selectAddress(int index, List<Map<String, dynamic>> addresses) async {
    setState(() {
      selectedIndex = index;  // Update the selected index
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Mark the selected address and reset others to false
      for (int i = 0; i < addresses.length; i++) {
        addresses[i]['selected'] = (i == index);  // Set the selected field to true for the selected address
      }

      // Update the entire list of addresses in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(user.email).update({
        'addresses': addresses,  // Update the 'addresses' field with the modified list
      });
    }
  }

  // Show dialog for editing address
  void _editAddress(int index, List<Map<String, dynamic>> addresses) {
    final address = addresses[index];
    _flatController.text = address['flat'] ?? '';
    _areaController.text = address['area'] ?? '';
    _landmarkController.text = address['landmark'] ?? '';
    _townController.text = address['town'] ?? '';
    _pincodeController.text = address['pincode'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            alignment: Alignment.center,
            backgroundColor: Colors.black87,
            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_outlined, size: 30, color: Colors.indigo),
                ),
                SizedBox(width: 15),
                Text(
                  "Edit Address",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ],
            ),
            content: Container(
              height: MediaQuery.of(context).size.height*0.8,
              width: MediaQuery.of(context).size.width*0.9,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("  Flat, House no., Building, Company, Apartment", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1, overflow: TextOverflow.ellipsis)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _flatController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.house, color: Colors.orange.shade900),
                        hintText: "Flat",
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
                    child: Text("  Area, Street, Sector, Village", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1, overflow: TextOverflow.ellipsis)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _areaController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city, color: Colors.green.shade900),
                        hintText: "Area",
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
                    child: Text("  Landmark", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _landmarkController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.landscape, color: Colors.purple.shade900),
                        hintText: "Landmark",
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
                    child: Text("  Town/City", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _townController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.place, color: Colors.blue.shade900),
                        hintText: "Town",
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
                    child: Text("  Pincode", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: _pincodeController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.pin_drop, color: Colors.red.shade900),
                        hintText: "Pincode",
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
                        _saveAddress(index, addresses);
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    height: 65,
                    width: 350,
                    child: ElevatedButton(
                      onPressed: () => _saveAddress(index, addresses),
                      child: Text(
                        "Save",
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
          ),
        );
      },
    );
  }

  Future<void> _saveAddress(int index, List<Map<String, dynamic>> addresses) async {
    // Check if any of the fields are empty
    if (_flatController.text.isEmpty ||
        _areaController.text.isEmpty ||
        _landmarkController.text.isEmpty ||
        _townController.text.isEmpty ||
        _pincodeController.text.isEmpty) {
      return; // Do not proceed if any field is empty
    }

    // Create the updated address map
    final updatedAddress = {
      'flat': _flatController.text,
      'area': _areaController.text,
      'landmark': _landmarkController.text,
      'town': _townController.text,
      'pincode': _pincodeController.text,
      'selected': addresses[index]['selected'] ?? false,
    };

    // Update the address in the list
    addresses[index] = updatedAddress;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update the Firestore document with the modified addresses
      await FirebaseFirestore.instance.collection('Users').doc(user.email).update({
        'addresses': addresses,
      });
    }

    // Close the dialog
    Navigator.pop(context);

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Address updated successfully."),
      ),
    );
  }

  // Function to delete an address
  void _deleteAddress(int index, List<Map<String, dynamic>> addresses) {
    final address = addresses[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text("Delete Address", style: TextStyle(color: Colors.white)),
          content: Text("Are you sure you want to delete this address?", style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog if "Cancel" is pressed
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Remove the address from the list
                addresses.removeAt(index);

                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Update the 'addresses' field in Firestore with the updated list of addresses
                  await FirebaseFirestore.instance.collection('Users').doc(user.email).update({
                    'addresses': addresses,
                  });
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Address deleted successfully"),
                  ),
                );

                Navigator.pop(context);  // Close the dialog after the deletion
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text("Select a location"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(height: 25),
            SizedBox(
              height: 65,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Address()),
                  );
                },
                child: Text(
                  'Add new address',
                  style: TextStyle(fontSize: 22.5, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue.shade900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            SizedBox(height: 25),
            Text("Saved Addresses", style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 25),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: addressStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.blue.shade900));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching addresses'));
                  }
                  final addresses = snapshot.data ?? [];
                  if (addresses.isEmpty) {
                    return Center(child: Text("No saved addresses found", style: TextStyle(color: Colors.white, fontSize: 20)));
                  }

                  return ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isSelected = selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: ListTile(
                          tileColor: isSelected ? Colors.blue.shade800 : Colors.white10,
                          title: Text(
                            "${address['flat']}, ${address['area']}, ${address['landmark']}, ${address['town']}, ${address['pincode']}",
                            style: TextStyle(fontSize: 17.5, color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onTap: () {
                            _selectAddress(index, addresses); // Select the address and update Firestore
                          },
                          trailing: PopupMenuButton(

                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            color: Colors.black87,
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Edit',style: TextStyle(color: Colors.white,fontSize: 17.5))),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Delete',style: TextStyle(color: Colors.red,fontSize: 17.5))),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editAddress(index, addresses);
                              } else if (value == 'delete') {
                                _deleteAddress(index, addresses);
                              }
                            },
                          ),
                        ),
                      );
                    },
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
