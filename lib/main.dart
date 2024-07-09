import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          dividerColor: Colors.black,
          indicatorColor: Colors.black,
          labelColor: Colors.blue.shade800,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        scaffoldBackgroundColor: Colors.black,
        drawerTheme: DrawerThemeData(
            backgroundColor: Colors.black,
            width: MediaQuery.of(context).size.width * 0.7),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22.5),
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(size: 25, color: Colors.indigo)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(color: Colors.indigo, size: 25),
          unselectedIconTheme: IconThemeData(color: Colors.grey, size: 25),
          selectedLabelStyle: TextStyle(fontSize: 18, color: Colors.indigo),
          unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.grey),
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
        ),
        splashColor: Colors.black,
        highlightColor: Colors.black,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor:
              Colors.blueAccent, // Color of the selected text background
          cursorColor: Colors.blue.shade900, // Color of the cursor
          selectionHandleColor:
              Colors.blue.shade900, // Color of the selection handles
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Splash1(),
    );
  }
}
