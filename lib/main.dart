/*import 'package:app/intro%20pages/activities.dart';
import 'package:app/intro%20pages/agepage.dart';
import 'package:app/intro%20pages/colestrol.dart';
import 'package:app/intro%20pages/currentlevel.dart';
import 'package:app/intro%20pages/heightpage.dart';
import 'package:app/intro%20pages/weightpage.dart';
import 'package:app/pages/calories.dart';
*/
import 'package:app/pages/workout.dart';

import 'package:app/intro%20pages/genderpage.dart';
import 'package:app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'package:app/pages/login.dart';
//import 'package:app/pages/register.dart';
import 'package:app/pages/home.dart';
//import 'package:app/intro%20pages/goalscreen.dart';

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
      home: FitnessDashboardScreen(),
      
    );
  }
}
