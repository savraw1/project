import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/login.dart';

class Signup1 extends StatefulWidget {
  const Signup1({super.key});

  @override
  State<Signup1> createState() => _Signup1State();
}

class _Signup1State extends State<Signup1> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FocusNode _cpasswordFocus = FocusNode();

  bool turn1 = true;
  bool turn2 = true;

  Future<void> _register() async {
    try {
      String Username = username.text.toLowerCase().trim();
      String Email = email.text.toLowerCase().trim();
      String Phone = phone.text.trim();
      String Password = password.text.trim();
      String Cpassword = cpassword.text.trim();

      // Check if passwords match
      if (Password != Cpassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: Email.toLowerCase(),
        password: Password,
      );

      // Firestore instance
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check if username is already taken
      final QuerySnapshot existingUser = await firestore
          .collection("Users")
          .where("email", isEqualTo: Email)
          .get();

      if (existingUser.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username already taken")),
        );
        return;
      }

      // Store user information in Firestore using username as document ID
      await firestore.collection("Users").doc(Email).set({
        "username": Username,
        "email": Email,
        "phone": Phone,
        "profilepic": "", // Optionally set a default profile picture URL
      });

      // Navigate to the login page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login1()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to register: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo.shade700,
                        Colors.indigo.shade800,
                        Colors.indigo.shade900,
                        Colors.indigoAccent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 40,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
              Positioned(
                top: 195,
                left: 22.5,
                height: MediaQuery.of(context).size.width * 1.6,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 35),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: username,
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
                      SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: email,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.red),
                            hintText: "Email",
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
                      SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: phone,
                          keyboardType: TextInputType.number,
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
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: password,
                          obscureText: turn1,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.brown.shade700),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                            suffixIcon: TextButton(
                              child: Text(turn1 ? "Show" : "Hide", style: TextStyle(color: Colors.black, fontSize: 17.5)),
                              onPressed: () {
                                setState(() {
                                  turn1 = !turn1;
                                });
                              },
                            ),
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
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_cpasswordFocus);
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: cpassword,
                          focusNode: _cpasswordFocus,
                          obscureText: turn2,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.brown.shade700),
                            hintText: "Confirm password",
                            hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                            suffixIcon: TextButton(
                              child: Text(turn2 ? "Show" : "Hide", style: TextStyle(color: Colors.black, fontSize: 17.5)),
                              onPressed: () {
                                setState(() {
                                  turn2 = !turn2;
                                });
                              },
                            ),
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
                          onEditingComplete: _register, // Trigger registration on enter
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: ElevatedButton(
                          onPressed: _register,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login1()));
                            },
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
