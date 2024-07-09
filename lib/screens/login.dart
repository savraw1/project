import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/bottom/bottom.dart';
import 'package:project/screens/signup.dart';
import 'package:project/screens/user/home.dart';

class Login1 extends StatefulWidget {
  const Login1({super.key});

  @override
  State<Login1> createState() => _Login1State();
}

class _Login1State extends State<Login1> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool turn = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    try {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (email == "admin@gmail.com") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bot1()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home1()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to log in: $e')));
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
                top: 150,
                left: 40,
                child: Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
              Positioned(
                top: 325,
                left: 22.5,
                height: MediaQuery.of(context).size.width * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.75,
                        child: TextField(
                          controller: emailController,
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
                        width: MediaQuery.of(context).size.width*0.75,
                        child: TextField(
                          controller: passwordController,
                          obscureText: turn,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.brown.shade700),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                            suffixIcon: TextButton(
                              child: Text(turn ? "Show" : "Hide",style: TextStyle(color: Colors.black,fontSize: 17.5)),
                              onPressed: () {
                                setState(() {
                                  turn = !turn;
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
                          onEditingComplete: () => _login(context), // Trigger login on enter
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width*0.75,
                        child: ElevatedButton(
                          onPressed: () => _login(context),
                          child: Text(
                            "Log In",
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
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Signup1()),
                              );
                            },
                            child: Text(
                              "Sign up",
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