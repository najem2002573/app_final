
import 'package:app/intro%20pages/agepage.dart';
import 'package:app/intro%20pages/genderpage.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/register.dart';
import 'package:app/services/appUser.dart';
import 'package:app/services/manager.dart';
import 'package:app/services/nutrients.dart';
import 'package:app/services/userDATA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

//the app <??<>??>
//17.4.25 updates
void main() async {
  //manager class instance that is static and manger all across the app
  BackendManager manager=BackendManager();

  //load env file
  //await dotenv.load(fileName: "android/Keys.env");


  WidgetsFlutterBinding.ensureInitialized(); // Ensures Firebase initializes properly
  await Hive.initFlutter();
   // Register adapter (this is auto-generated)
  Hive.registerAdapter(AppUserAdapter());
  Hive.registerAdapter(NutrientsAdapter());
  Hive.registerAdapter(UserdataAdapter());

  //open the boxes of local storages
  await Hive.openBox<AppUser>('userBox');
  await Hive.openBox<Nutrients>('nutrientsBox');
  await Hive.openBox<Userdata>('userData');
 
 //the instance of the firebase user object

  
  // Load saved nutrients, in this function in the manager we check the local data and if its not there 
  //we load it from the fireabse 
  await manager.loadTodayNutrients();
  
  //to load 


  //Starting the firebase when the app launches
  await Firebase.initializeApp().then((_){
    print("its on!!!!");
  }).catchError((e){
    print("not successfull");
   
  }); // Initialize Firebase

 final user = FirebaseAuth.instance.currentUser;
 String uid=user?.uid ?? "";

print("in the main for the current instance of user the uid is : $uid");
manager.setUid(uid);
 //check the userData (weight, height... ) locally and load them from the firebase if needed
 Box userdata=Hive.box<Userdata>("userData");
 if(userdata.get('userdata')==null){
  if(uid!="") {
    print('the uid in the very main is : $uid');
    await manager.initializeUserData(uid, userdata);
  }
 }
//to make the app remeber the user (if signed in he wont face the sign in page again)
//by checking the isSigned attribute of the user which is saved in the hive

  final box = Hive.box<AppUser>('userBox');
  final currentUser = box.get('currentUser');
  
  



// most important: change to this line in firestore rules: allow read, write: if request.auth != null;
//so just real users can read and write and not every one

  runApp(MyApp(
    isSignedIn: currentUser?.isSignedIn ?? false,
  )); // Start your app
}

class MyApp extends StatefulWidget {
  final bool isSignedIn;

  const MyApp({super.key, required this.isSignedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _startScreen =  SignInScreen(); // default

  @override
  void initState() {
    super.initState();
    _handleStartupLogic();
  }

  Future<void> _handleStartupLogic() async {
    if (widget.isSignedIn) {
      final box = Hive.box<AppUser>('userBox');
      AppUser? localUser = box.get('currentUser');

      if (localUser == null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (doc.exists) {
            final data = doc.data();
            final appUser = AppUser(
              uid: user.uid,
              username: data?['username'] ?? '',
              email: data?['email'] ?? '',
            );
            print('app user name in the main function that is loaded locally and by firebase is:  ${appUser.username} and from the local is ${localUser?.username}');
            box.put('currentUser', appUser);
            _startScreen =  HomePage();
          } else {
            // If Firebase user exists but no document found
            _startScreen =  SignInScreen();
          }
        }
      } else {
        _startScreen =  HomePage(); // user is signed in and local data exists
      }
    } else {
      _startScreen =  SignInScreen();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}




