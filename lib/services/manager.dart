
import 'package:app/pages/food.dart';
import 'package:app/services/appUser.dart';
import 'package:app/services/gym.dart';
import 'package:app/services/nutrients.dart';
import 'package:app/services/userDATA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';  // For File
import 'package:image_picker/image_picker.dart';  // For ImagePicker and XFile
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';





//safe project
//define image picker

// its safe now
final picker = ImagePicker();


class BackendManager
{
 
  String profile_image_path="";

  void setProfiePath(String path){
    this . profile_image_path=path;
  }


  String getProfileImagePath(){
    return this.profile_image_path;
  }

  String username="";

  void setUname(String name){
    this.username=name;
  }

  String getUname(){
    return this . username;
  }

  //creating a singelton to make all instances static and access real time  data vars 
  static final BackendManager _instance = BackendManager._internal();
  factory BackendManager() => _instance;
  BackendManager._internal();


  // the Users postion and the nearby gyms list
  Position myPos=Position(longitude: 0, latitude: 0, timestamp: DateTime(0), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  List<Gym> gymsList=[];



  //to make tge use retrieve the position and gyms
  Position getPos(){return this.myPos;}
  List<Gym> getGyms(){return this.gymsList;}

  //the nutrients for this specific day, must check the date and if this day ends we reset the object
  Nutrients todayNutrints=Nutrients();
  

  //to get this object
  Nutrients getNutrientValues() {
    return todayNutrints;
}


//load the todayNutrients from the hive or if its not there get it from the firebase
Future<void> loadTodayNutrients() async {

  final box = await Hive.openBox<Nutrients>('nutrientsBox');
  Nutrients? loaded=box.get('today');

  if (loaded!=null){// if local data exists
  todayNutrints.protein = (loaded?.protein ?? 0.0).toDouble();
  todayNutrints.carbs = (loaded?.carbs ?? 0.0).toDouble();
  todayNutrints.fats = (loaded?.fats ?? 0.0).toDouble();
  todayNutrints.sugars = (loaded?.sugars ?? 0.0).toDouble();
  todayNutrints.calories = (loaded?.calories ?? 0.0).toDouble();
  todayNutrints.waterGlasses = (loaded?.waterGlasses ?? 0.0).toInt();
  
  }
 else{ // or we load it from fireabse 

    if(this.uid.isEmpty)
    {
    print("❌ UID is empty. Cannot fetch nutrients.");
    return;
  }

  try {
    final doc = await FirebaseFirestore.instance.collection('nutrients').doc(uid).get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;

      
        todayNutrints.calories=(data['calories'] ?? 0).toDouble();
        todayNutrints.protein= (data['protein'] ?? 0).toDouble();
        todayNutrints.carbs=(data['carbs'] ?? 0).toDouble();
        todayNutrints.fats=(data['fats'] ?? 0).toDouble();
        todayNutrints.fats=(data['sugars'] ?? 0).toDouble();
        todayNutrints.fats=(data['water'] ?? 0).toDouble();

      await box.put('today', todayNutrints);
      print("✅ Nutrients fetched and stored in Hive.");
    } else {
      print("❌ No nutrients data found for user.");
    }
  } catch (e) {
    print("❌ Error fetching nutrients: $e");
  }

 }

  }




  

  Future<void> uploadTodayNutrientsFirebase()async{
    
    final user = FirebaseAuth.instance.currentUser;
    
    if (this.uid.isEmpty) {
    print("❌ UID is empty. Cannot upload nutrients.");
    print("the found uid is : $uid");
    return;
  }

  try {
    final nutrientsDoc = FirebaseFirestore.instance.collection('nutrients').doc(uid);

    await nutrientsDoc.set({
      'calories': todayNutrints.calories,
      'protein': todayNutrints.protein,
      'carbs': todayNutrints.carbs,
      'fats': todayNutrints.fats,
      'sugars': todayNutrints.sugars,
      'water':todayNutrints.waterGlasses,
      'date': Timestamp.now(), // optional for tracking when it was uploaded
    });

    print("✅ Nutrients uploaded to Firebase.");
  } catch (e) {
    print("❌ Error uploading nutrients: $e");
  }


  }

//food part of backend
//connect to local image model to detect food , then connect to open ai to get the nutrients
//used variables


///////////////////////////////////////////  IMAGE DETECTION AND NUTRINETS AI GET PART ////////////////////

 String aiKey="";
 String GpsKey="";

  

Future<void> loadKeys()async{
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  String googleApiKey = _remoteConfig.getString('google_api');
  String openAiKey =_remoteConfig.getString('open_AI');

  this.aiKey=openAiKey;
  this.GpsKey=googleApiKey;
    print("Google API Key: $googleApiKey");
    print("OpenAI Key: $openAiKey");
  

}



Future<String> pickAndUploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Or use .camera for camera

  if (pickedFile==null){
    getNutrients("");
    print("nutrients are not found because yu did not choose an image");
    return "";

  } 


  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes();
    print("picked the image and its good");
    // Send image to FastAPI
    final response = await sendImageToAPI(bytes);

    //after getting the name of the food send it to US DATA to get its nutrients
    print(response.toString());
    //getNutrients(response.toString());

    if (response != null) {
      print("the response is good,***");
      print('Predicted Label: ${response['predicted_label']}');
      return response.toString();
    }
    return "no label err";
  }
  else{
    print("failed");
    return "no label found";
  }
}






//using custome image model to identify food
Future<Map<String, dynamic>?> sendImageToAPI(Uint8List imageBytes) async {
  final uri = Uri.parse('http://10.0.2.2:8000/predict/');
  final request = http.MultipartRequest('POST', uri);

  // Add the image as a file
  request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      print("response is good");
      final responseData = await response.stream.bytesToString();
      print("the data is : "+responseData);
      return jsonDecode(responseData);
    } else {
      print('Failed to get prediction');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}


 Future<Map?> getNutrients(String foodItem) async {
  // API key
  final String apiKey = aiKey; 
  final String apiUrl = "https://api.openai.com/v1/chat/completions";

  if(foodItem==""){
    print("no food name so no nutrients");
    return null;
  }


  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo", // Use GPT-3.5 or GPT-4 model as per your requirement
        "messages": [
          {
            "role": "user",
            "content":
                "give me carbs, protein, calories, fats, and sugars of $foodItem in json format with no explanation"
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final message = responseData['choices'][0]['message']['content'];
      print("code is good now the response is: ");

      final values = jsonDecode(message);
      print(values);

      // Extract values as strings, then parse them to doubles
      double fats = _parseNutrient(values['fats']);
      double proteins = _parseNutrient(values['protein']);
      double carbs = _parseNutrient(values['carbs']);
      double sugars = _parseNutrient(values['sugars']);
      double calories = _parseNutrient(values['calories']);

      // Set today's nutrients:
      todayNutrints.addCarbs(carbs);
      todayNutrints.addFats(fats);
      todayNutrints.addProtein(proteins);
      todayNutrints.addSugars(sugars);

      print("each var value of ");
      print(foodItem+"is :");
      print("$fats - $sugars - $carbs - $calories - $proteins");
      
      
      return values; // Return the data after parsing and setting it
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error occurred: $error');
  }
}

// Helper function to parse nutrient values from a string (removes the unit and converts to double)
double _parseNutrient(String nutrient) {
  // Remove any non-numeric characters (like 'g') and parse the remaining value
  final numericValue = nutrient.replaceAll(RegExp(r'[^0-9.]'), '');
  return double.tryParse(numericValue) ?? 0.0; // Default to 0.0 if parsing fails
}












///============================================================================================================
///============================================================================================================///============================================================================================================

///============================================================================================================
///============================================================================================================

///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================
///============================================================================================================

//                                        THE GPS PART



Future<Position?> getLocation() async{
  LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
    }

  if(await Geolocator.requestPermission()==LocationPermission.denied)
  {
    print("no location granted, error");
    return null;
  }

  else{

  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  print("my location is");
  print('Current location: ${position.latitude}, ${position.longitude}');
  
  myPos=position;
  return position;
}
}


Future<List<Gym>> callPlacesApi(Position position) async{
  final apiKey = GpsKey;
final type = 'gym'; // or 'park'
final url = Uri.parse(
  'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=2000&type=$type&key=$apiKey',
);

final response = await http.get(url);
final data = jsonDecode(response.body);
final places=data['results'];
print("the nearby locations are : ");
print(data['results']);

//data['result'] has the places we searched
List<Gym> gymlist=[];

for (var gym in places){
    final name = gym['name'];
    final lat = gym['geometry']['location']['lat'];
    final lng = gym['geometry']['location']['lng'];
// Fetch opening hours if available
    final openingHours = gym['opening_hours'] != null
        ? gym['opening_hours']['open_now']  // 'open_now' boolean
        : null;

    // Optionally, fetch detailed periods if available
    final periods = gym['opening_hours'] != null
        ? gym['opening_hours']['periods']
        : null;

    Gym gm = Gym(
      name: name,
      lat: lat,
      long: lng,
      openNow: openingHours,
      periods: periods,
    );

    gymlist.add(gm);
  }
print("the set of gyms");
print(gymlist.toSet());
//test the output : name of gym - lat - long - open hours :variables
/*
  for (var place in places.take(5)) {
    final name = place['name'];
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    final openNow = place['opening_hours']?['open_now'] ?? false;

    print('🏋️‍♂️ $name');
    print('📍 Location: $lat, $lng');
    print('🕒 Open Now: ${openNow ? 'Yes' : 'No'}');
    print('---');
  } 
  */

  print("the gym list length is : ");
  

  this.gymsList=gymlist;
  return gymlist;
}


Future<void> addTestWorkout() async {
  try {
    // Log to see when the function is called
    print('Adding workout to Firestore...');

    // Add the workout data to the 'workouts' collection
    await FirebaseFirestore.instance.collection('workouts').add({
      'name': 'Chest Day', // Name of the workout
      'duration': 19, // Duration in minutes
      'date': Timestamp.now(), // Current timestamp
      'exercises': ['Push-ups', 'Bench Press'], // List of exercises
    });

    // Log success message
    print('Workout added successfully!');
    
  } catch (e) {
    // Log error message if anything goes wrong
    print('Error adding workout: $e');
  }
}



Future<void> retrieveWorkouts() async {
  try {
    // Get the collection of workouts
    QuerySnapshot workoutsSnapshot = await FirebaseFirestore.instance.collection('workouts').get();
    
    // Loop through each document in the collection
    workoutsSnapshot.docs.forEach((doc) {
      // Get the document ID and data
      String docId = doc.id;
      Map<String, dynamic> workoutData = doc.data() as Map<String, dynamic>;
      
      // Now you can access the data, like:
      print("Workout ID: $docId");
      print("Workout Name: ${workoutData['name']}");
      print("Duration: ${workoutData['duration']}");
      print("Exercises: ${workoutData['exercises']}");
    });
  } catch (e) {
    print('Error retrieving workouts: $e');
  }
}


//###############################################################################################################
//###############################################################################################################
//###############################################################################################################
//###############################################################################################################

                              //AUTH AND HIVE LOCAL CACHING + USER NAME
//test the hive Storage
Future<void> testHive() async {
  final box = Hive.box<AppUser>('userBox');

  // Create dummy user
  final user = AppUser(
    uid: '123abc',
    username: 'Test User',
    email: 'test@example.com',
    isSignedIn: true,
  );

  await box.put('currentUser', user);

  final retrievedUser = box.get('currentUser');

  if (retrievedUser != null) {
    print("Hive stored: ${retrievedUser.username} and its working and his mail is ${retrievedUser.email}");
  } else {
    print("Hive failed to store user and cant get him becuase he is null");
  }
}





// to store the user when getting his data from the register page
Future<void> cacheUser(AppUser user) async{

  //the check if the user is null or not is in the register page when we asked if the user
  //is not null ! then save it inside the manager
  final box=Hive.box<AppUser>('userBox');
  print("will cache the user , its id : ${this.uid}");
  await box.put('currentUser', user);
  await updateUserInDatabase(user);/// so always when changing any user data we update it in DB
  final retrieve=await box.get('currentUser');
  if (retrieve!=null)
  print("done storing the registered user locally, his name is ${retrieve.username} and his email is ${retrieve.email}");
 
}

// update user data such as gmail and name on the database
Future<void> updateUserInDatabase(AppUser user) async {


  print("for uploading new user name the uid is : ${this.uid}");
  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
    'username': user.username,
  });
}


////////////////////////////////////////////  USER DATA AS HEIGHT WEIGHT ............//////////////////////


// saving user data

int age=0; String goal=""; String gender=""; double HEIGHT=0; double WEIGHT=0;String activity_level="";
String uid="";

Map<String,dynamic> getUserDat(){
  Map<String,dynamic> userDat={
    'weight':this.WEIGHT,
    'height':this.HEIGHT,
    'age':this.age,

  };

  return userDat;
}


String getUid(){
  return uid;
}

void setUid(String uid){
  this.uid=uid;
  print("this.uid is ${this.uid}}");
  //Box box=Hive.box<AppUser>('userBox');
  //this.uid=box.get('currentUser').uid;
  //print("the uid is setted in the manager is $uid");
}

//set all variables
void setAge(int age){
  print("manager got age $age");
  this.age=age;
  }


void setHeight(double height){
  print("manager got $height");
  this.HEIGHT=height;}


void setWeight(double weight){
  print("manager got $weight");
  this.WEIGHT=weight;}


void setActivityLevel(String activity_level){
  print("manager got $activity_level");
  this.activity_level=activity_level;}


void setGoal(String goal){
  print("manager got $goal");
  this.goal=goal;}


void setGender(String gender){
  print("manager got $gender");
  this.gender=gender;
  print("the manager gender var is ${this.gender}");
  }

void printData(){
  print("age is $age and height is $HEIGHT and weight is $WEIGHT and gender is $gender and goal is $goal");
}

//save the data to local storage
void createLocalUserData() {
  Box box = Hive.box<Userdata>('userData');
  Userdata data = Userdata(
    uid: this.uid,
    age: this.age,
    goal: this.goal,
    gender: this.gender,
    height: this.HEIGHT,
    weight: this.WEIGHT,
    activityLevel: this.activity_level, // Ensure this is being set properly
  );

  // Debugging print
  print("Creating user data in local storage: $data");

  box.put('userdata', data);
}






//save data to firebase
Future<void> uploadUserDataToFirebase() async {
  if (uid.isEmpty) {
    print("UID is empty. Cannot upload user data.");
    return; // Prevent uploading if UID is empty
  }

  // Retrieve data from Hive
  Box userDataBox = Hive.box<Userdata>('userData');
  Userdata userData = userDataBox.get('userdata');  // Ensure you're retrieving the correct data
  print("user data before firebase upload are: ${userData.uid} and heigt is : ${userData.height} ");
  if (userData == null) {
    print("User data is empty. Cannot upload to Firebase.");
    return;
  }

  try {
    final userDoc = FirebaseFirestore.instance.collection('userdata').doc(uid);

    // Upload the data
    await userDoc.set({
  'goal': userData.goal,
  'height': userData.height,
  'weight': userData.weight,
  'age': userData.age,
  'gender': userData.gender,
  'activity_level': userData.activityLevel,
  'last_updated': DateTime.now().toIso8601String(),
}, SetOptions(merge: true)); // add this

    final snapshot = await userDoc.get();
    print("📦 Firebase doc after upload: ${snapshot.data()}");


    print("User data uploaded to Firebase successfully.");
  } catch (e) {
    print("❌ Error uploading user data: $e");
  }
}


// to bring the user data from the firebase if the userData box is empty
Future<void> initializeUserData(String uid,Box box) async {
  // Open the Hive box if not opened already
  

  // Check if user data exists locally
  if (box.get('userdata') == null) {
    print("📦 Hive box is empty. Trying to fetch from Firebase...");

    try {
      // Get the user document from Firebase
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        // Convert to  Userdata object
        Userdata userData = Userdata(
          uid: uid,
          gender: data['gender'],
          age: data['age'],
          height: data['height'],
          weight: data['weight'],
          goal: data['goal'],
          activityLevel: data['activity_level'],
        );

        // Store in Hive
        await box.put('userdata', userData);
        print("✅ Data fetched and stored in Hive.");

        // You can also update your manager vars here if needed
        updateFromUserdata(userData);
      } else {
        print("❌ No such user in Firebase.");
      }
    } catch (e) {
      print("❌ Error fetching user data from Firebase: $e");
    }
  } else {
    print("✅ Hive already has user data.");
  }
}

void updateFromUserdata(Userdata data) {
    this.gender = data.gender;
    this.HEIGHT = data.height;
    this.WEIGHT = data.weight;
    this.age = data.age;
    this.goal = data.goal;
    this.activity_level = data.activityLevel;
    print("🧠 Manager updated from Firebase.");
  }


String deleteNutrients(){
  Box box=Hive.box<Nutrients>('nutrientsBox');
  box.clear();
  return 'clear';
}


/*
var workoutsData = {
      'keep_fit': [
        {'name': 'Keep fit', 'duration': 60, 'exercises': ['Bodyweight Squats', 'Push-ups','Plank','Lunges','Jumping Jacks','Mountain Climbers','Superman Hold','	Tricep Dips','Bicycle Crunches','Glute Bridges','Wall Sit','Step-Ups']},
      ],
      'lift_for_strength': [
        {'name': 'Chest Day', 'duration': 50, 'exercises': ['Bench Press', 'Incline Dumbbell Press','Cable Crossover','seated cable fly','Chest Dips','Decline Bench Press','Push-Ups']}
        {'name': 'Back Day', 'duration': 50, 'exercises': ['Lat Pulldown', 'Pull-Ups (Wide Grip)','Barbell Deadlift','Bent-Over Barbell Row','Seated Cable Row','T-Bar Row','Straight Arm Pulldown']}
        {'name': 'Leg Day', 'duration': 50, 'exercises': ['Barbell Back Squat', 'Romanian Deadlift','Walking Lunges','seated cable fly','Bulgarian Split Squat','Leg Curl','Standing Calf Raises']}
        {'name': 'Biceps Day', 'duration': 40, 'exercises': ['Barbell Curl', 'Dumbbell Alternating Curl','Hammer Curl','Preacher Curl','Concentration Curl','Cable Curl (Low Pulley)','Incline Dumbbell Curl']}
        {'name': 'Triceps  Day', 'duration': 40, 'exercises': ['Close-Grip Bench Press', 'Triceps Dips (Bodyweight or Weighted)','Skull Crushers (Lying Triceps Extensions)','Overhead Dumbbell Triceps Extension','Triceps Pushdown (Cable - Rope or Bar)','Dumbbell Kickbacks','Diamond Push-Ups']}
        {'name': 'Sholder Day', 'duration': 40, 'exercises': ['Overhead Press', 'Lateral Raises','Front Dumbbell Raises','Rear Delt Fly','Arnold Press','Upright Rows','Face Pulls']}
        {'name': 'Abs Day', 'duration': 30, 'exercises': ['Hanging Leg Raises', 'Cable Crunches','Russian Twists','Plank','Bicycle Crunches','V-Ups','Mountain Climbers']}
        {'name': 'Full body Day', 'duration': 90, 'exercises': ['Barbell Squats', 'Walking Lunges','Deadlifts','Bench Press','Overhead Press','Dips','Barbell Curls','Hanging Leg Raises','	Plank']}

      ],
      'cardio': [
        {'name': 'cardio day', 'duration': 60, 'exercises': ['Jump Rope', '	High Knees','	Burpees','Mountain Climbers','Jumping Jacks','Skater Hops','Butt Kicks','Stair Running','Sprint Intervals','Rowing Machine','Jump Squats','	Shadow Boxing']}
      ]
    };

*/

// local user data variable , uplaoded when the app runs first time so manager parameters are loaded
Future<void> loadUserData(String userId) async {
  print("now loading all user data, if it's not hived then load it from Firebase via the uid");

  final userBox = Hive.box<Userdata>('userData');
  final data = userBox.get(userId);

  if (data != null) {
    // 🔹 Load from Hive
    print("Loaded from Hive");
    this.HEIGHT = data.height;
    this.WEIGHT  = data.weight;
    this.goal  = data.goal;
    this.age  = data.age;
    this.gender = data.gender;
    this.activity_level = data.activityLevel; 
    print("Loaded from Hive: $age, $goal, $activity_level");
  } else {
    // 🔸 Load from Firebase
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        final firebaseData = doc.data();
        if (firebaseData != null) {
          final dat = Userdata(
            uid: firebaseData['uid'] ?? "",
            age: firebaseData['age'] ?? 0,
            goal: firebaseData['goal'] ?? "",
            gender: firebaseData['gender'] ?? "",
            height: firebaseData['height'] ?? 0.0,
            weight: firebaseData['weight'] ?? 0.0,
            activityLevel: firebaseData['activity_level'] ?? "",
          );
          await userBox.put(userId, dat); // ✅ save with same key

          this.HEIGHT = dat.height;
          this.WEIGHT = dat.weight;
          this.goal = dat.goal;
          this.age = dat.age;
          this.gender = dat.gender;
          this.activity_level = dat.activityLevel;

          print("Loaded from Firebase and saved to Hive: $age, $goal, $activity_level");
        }
      }
    } catch (e) {
      print("❌ Error loading user data: $e");
    }
  }
}









//################################################# THE END ###################################################
//################################################# THE END ###################################################
//################################################# THE END ###################################################
}//end of backend manager class













