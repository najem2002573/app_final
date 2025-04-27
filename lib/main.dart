
import 'package:app/pages/home.dart';
import 'package:app/pages/login.dart';
import 'package:app/services/appUser.dart';
import 'package:app/services/manager.dart';
import 'package:app/services/nutrients.dart';
import 'package:app/services/userDATA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';




//the app <??<>??>
//17.4.25 updates must have no key.  test if env is not there


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults({
  'google_api': 'default_google_key',
  'open_AI': 'default_openai_key',
});

  await remoteConfig.fetchAndActivate();
  print("Remote Config initialized successfully!");
}



void main() async {
WidgetsFlutterBinding.ensureInitialized(); // Ensures Firebase initializes properly


  //manager class instance that is static and manger all across the app
  BackendManager manager=BackendManager();

  


  

  await Hive.initFlutter();
   // Register adapter (this is auto-generated)
  Hive.registerAdapter(AppUserAdapter());
  Hive.registerAdapter(NutrientsAdapter());
  Hive.registerAdapter(UserdataAdapter());

  //open the boxes of local storages
  await Hive.openBox<AppUser>('userBox');
  await Hive.openBox<Nutrients>('nutrientsBox');
  await Hive.openBox<Userdata>('userData');
  await Hive.openBox('profileimageBox');
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

await initializeRemoteConfig(); // init the remote the stores api keys

// load the api keys
manager.loadKeys();

 final user = FirebaseAuth.instance.currentUser;
 String uid=user?.uid ?? "";
manager.loadUserData(uid);
print("in the main for the current instance of user the uid is : $uid");
manager.setUid(uid);
 //check the userData (weight, height... ) locally and load them from the firebase if needed
 Box userdata=Hive.box<Userdata>("userData");
 if(userdata.get('userdata')==null){
  if(uid!="") {
    manager.setUid(uid);
    print('the uid in the very main is : $uid');
    await manager.initializeUserData(uid, userdata);
  }
 }
//to make the app remeber the user (if signed in he wont face the sign in page again)
//by checking the isSigned attribute of the user which is saved in the hive

  final boxUser = Hive.box<AppUser>('userBox');
  final currentUser = boxUser.get('currentUser');

// if local data is missing, bring it from the firebase

if(boxUser.isEmpty) {
  final currentuserDoc=await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .get();

    if(currentuserDoc.exists){
      final currUser=currentuserDoc.data();

      if(currUser!=null){
        final fetchedDataUser=AppUser(
        uid: uid, 
        username: currUser['username'], 
        email: currUser['email']);
        fetchedDataUser.SetIsSignedIn(true);

        boxUser.put('currentUser',fetchedDataUser);
        print("loaded from online the user values such as email, name and etc (the appUser class vars)");
      }
    }
}


  


// for notification reminder page /////////////////////////////

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Reminder triggered!");
    return Future.value(true);
  });
}

  // Initialize WorkManager
  Workmanager().initialize(
    callbackDispatcher, // Top-level callback function
    isInDebugMode: true, // Set to false in production
  );

  // Notification plugin initialization
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);

  flutterLocalNotificationsPlugin.initialize(initSettings);



////////////////////////////////////// ???????????????????????????????????????????
///


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

      String uname=""; // the user name will be loaded
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
            uname=appUser.username;
            manager.setUname(uname);
            _startScreen =  HomePage();
          } else {
            // If Firebase user exists but no document found
            _startScreen =  SignInScreen();
          }
        }
      } else {
         uname=localUser.username;
         manager.setUname(uname);
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




