
import 'package:app/intro%20pages/activities.dart';
import 'package:app/intro%20pages/agepage.dart';
import 'package:app/intro%20pages/currentlevel.dart';
import 'package:app/intro%20pages/genderpage.dart';
import 'package:app/intro%20pages/goalscreen.dart';
import 'package:app/intro%20pages/weightpage.dart';
import 'package:app/pages/food.dart';
import 'package:app/pages/manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/pages/home.dart';

//the app <??<>??>
//26.3.25
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
      
      home: DailyDietPage(),

    );
  }
}



