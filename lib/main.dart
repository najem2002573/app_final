
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/pages/home.dart';

//the app <??<>??>
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Firebase initializes properly
  await Firebase.initializeApp().then((_){
    print("its on!!!!");
  }).catchError((e){
    print("not successfull");
  }); // Initialize Firebase

  runApp(MyApp()); // Start your app
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),

    );
  }
}
