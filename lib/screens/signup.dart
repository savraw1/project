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
      String Username = username.text.trim();
      String Email = email.text.trim();
      String Phone = phone.text.trim();
      String Password = password.text.trim();
      String Cpassword = cpassword.text.trim();

      if (Password != Cpassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: Email,
        password: Password,
      );

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("Users").doc(userCredential.user!.uid).set({
        "username": Username,
        "email": Email,
        "phone": Phone,
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login1()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to register: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            top: 125,
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
            top: 225,
            left: 22.5,
            height: 690,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  SizedBox(
                    height: 100,
                    width: 350,
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
                  SizedBox(
                    height: 100,
                    width: 350,
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
                  SizedBox(
                    height: 100,
                    width: 350,
                    child: TextField(
                      controller: phone,
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
                  SizedBox(
                    height: 100,
                    width: 350,
                    child: TextField(
                      controller: password,
                      obscureText: turn1,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.brown.shade500),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        suffixIcon: TextButton(
                          child: Text(turn1 ? "Show" : "Hide",style: TextStyle(color: Colors.black,fontSize: 17.5)),
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
                      onSubmitted: (_){
                        FocusScope.of(context).requestFocus(_cpasswordFocus);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 350,
                    child: TextField(
                      controller: cpassword,
                      focusNode: _cpasswordFocus,
                      obscureText: turn2,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.brown.shade800),
                        hintText: "Confirm password",
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        suffixIcon: TextButton(
                          child: Text(turn2 ? "Show" : "Hide",style: TextStyle(color: Colors.black,fontSize: 17.5)),
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
                  SizedBox(
                    height: 65,
                    width: 350,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login1()));
                        },
                        child: Text(
                          "Sign in",
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
    );
  }
}