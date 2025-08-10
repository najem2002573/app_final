

import 'package:app/FireBase%20Service/FirebaseService.dart';
import 'package:app/debugger.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/workout.dart';
import 'package:app/services/appUser.dart';
import 'package:app/services/nutrients.dart';
import 'package:app/services/userDATA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';




//the app <??<>??>
//8.3.25 fkn updates



Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: Duration(seconds: 10),
    minimumFetchInterval: Duration.zero, // force fresh fetch
  ));

  await remoteConfig.setDefaults({
    'google_api': 'default_google_key',
    'open_AI': 'default_openai_key',
  });

  final success = await remoteConfig.fetchAndActivate();
  print("Remote Config fetch success: $success");

  final openAIKey = remoteConfig.getString('open_AI');
  print("🔑 Fetched OpenAI Key: $openAIKey");
}




//to load all important things within an await func


                                          Future<bool> prepareAppData() async{

                                            ////old init, old version of firebase cli 
                                            /*
                                                //Starting the firebase when the app launches
                                            await Firebase.initializeApp().then((_){
                                              print("its on!!!!");
                                            }).catchError((e){
                                              print("init the firebase not successfull");
                                            
                                            }); // Initialize Firebase     */

                                            //the new init for firebase
                                            await Firebase.initializeApp(
                                                options: DefaultFirebaseOptions.currentPlatform,
                                              );


                                           
                                            //get the api keys from the firebase remote config
                                            await initializeRemoteConfig(); // init the remote the stores api keys


                                            //seed all them data in firebase one time
                                            /*
                                            FirebaseService seeder=FirebaseService();
                                            seeder.uploadWorkoutsToPlans();
                                            */

                                            
                                            //init the hive (local stroage)
                                            await Hive.initFlutter();

                                            //register all them adapters
                                            // Register adapter (this is auto-generated)
                                            Hive.registerAdapter(AppUserAdapter());
                                            Hive.registerAdapter(NutrientsAdapter());
                                            Hive.registerAdapter(UserdataAdapter());



                                            //open the boxes of local storages
                                            await Hive.openBox<AppUser>('userBox');
                                            await Hive.openBox<Nutrients>('nutrientsBox');
                                            await Hive.openBox<Userdata>('userData');
                                            await Hive.openBox('profileimageBox');


                                            print("done oopenening all boxes in prep data");
                                            
                                            //prevent nulls 
                                            final firebaseUser = FirebaseAuth.instance.currentUser;
                                            if (firebaseUser != null && firebaseUser.uid.isNotEmpty) {
                                              manager.uid = firebaseUser.uid;
                                              print("✅ UID set: ${manager.uid}");
                                            } else {
                                              print("❌ No user signed in. UID not set.");
                                          }



                                          

  print("done getting the instance of the current user");

   //load the local user data via the manager class 
   await manager.loadUserData();
   print("done loading all user data from the manager class");
   //load the local today's nutrients via the manager class
   await manager.loadTodayNutrients();
   
   print("done getting the today nutrients from the manager class");
   final boxUser = Hive.box<AppUser>('userBox');
   final currentUser = boxUser.get('currentUser');

  print("getting the user from the user hive box");
   
   print("readched the end of prep app data, the value of the signed user is : ${currentUser?.isSignedIn == true} ");
   return currentUser?.isSignedIn == true;
;
}








void main() async {
WidgetsFlutterBinding.ensureInitialized(); // Ensures Firebase initializes properly


 

bool isSignedIn=await prepareAppData();
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  print("❌ No user signed in. Skipping Firestore fetch.");
  
}
else{
  final uid = user.uid;

  //here we get the uid from the firebase auth and store it to use it later 

  manager.setUid(uid);
}






//the fresh uid
final uid = FirebaseAuth.instance.currentUser?.uid;






  // load the api keys
  manager.loadKeys();


print(" for debuggin only, in the main for the current instance of user the uid is : $uid");



/// here we deal if the user is signed in but local data is missing, so we brough it from firebase and synced it with hive 
final boxUser = Hive.box<AppUser>('userBox');

if(boxUser.isEmpty) {

  final currentuserDoc=await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .get();

    if(currentuserDoc.exists){
      final currUser=currentuserDoc.data();
    if(uid!=null)
      // ignore: curly_braces_in_flow_control_structures
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


  






////////////////////////////////////// ???????????????????????????????????????????
///


// most important: change to this line in firestore rules: allow read, write: if request.auth != null;
//so just real users can read and write and not every one

runApp(MyApp(isSignedIn: isSignedIn)); // Start your app

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
    manager.isNew=true;
    _handleStartupLogic();

  }

Future<void> _handleStartupLogic() async {
  final box = Hive.box<AppUser>('userBox');
  final localUser = box.get('currentUser');

  if (localUser != null && localUser.isSignedIn) {
    // ✅ Local user exists and is signed in
    manager.setUname(localUser.username);
    setState(() {
      _startScreen = HomePage();
    });
    return;
  }

  // 🔍 Try Firebase fallback
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
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
        box.put('currentUser', appUser);
        manager.setUname(appUser.username);
        setState(() {
          _startScreen = HomePage();
        });
        return;
      }
    } catch (e) {
      print("❌ Firebase fetch failed: $e");
    }
  }

  // 🚪 Default to SignInScreen
  setState(() {
    _startScreen = SignInScreen();
  });


  
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _startScreen,
    );
  }


}
