import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  // TextEditingControllers to collect input
  final TextEditingController flatController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  // Function to save address to Firestore
  Future<void> _saveAddress() async {
    if (!_validateInputs()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle case if user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user logged in")),
      );
      return;
    }

    final address = {
      "flat": flatController.text,
      "area": areaController.text,
      "landmark": landmarkController.text,
      "town": townController.text,
      "pincode": pincodeController.text,
    };

    try {
      final userRef = FirebaseFirestore.instance.collection('Users').doc(user.email);
      await userRef.update({
        "addresses": FieldValue.arrayUnion([address])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Address saved successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save address: $e")),
      );
    }
  }

  bool _validateInputs() {
    if (flatController.text.isEmpty ||
        areaController.text.isEmpty ||
        landmarkController.text.isEmpty ||
        townController.text.isEmpty ||
        pincodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text("Add new address"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Flat, House no., Building, Company, Apartment",
                  style: TextStyle(fontSize: 17.5, color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: flatController,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white12,
                    filled: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 15),
              Text("Area, Street, Sector, Village",
                  style: TextStyle(fontSize: 17.5, color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: areaController,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white12,
                    filled: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 15),
              Text("Landmark",
                  style: TextStyle(fontSize: 17.5, color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: landmarkController,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white12,
                    filled: true,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Text("Town/City",
                          style:
                              TextStyle(fontSize: 17.5, color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            controller: townController,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.white12,
                              filled: true,
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Pincode",
                          style:
                              TextStyle(fontSize: 17.5, color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            controller: pincodeController,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.white12,
                              filled: true,
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              _saveAddress();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25),
              SizedBox(
                height: 75,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveAddress();
                  },
                  child: Text('Save and proceed',
                      style: TextStyle(fontSize: 22.5, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
