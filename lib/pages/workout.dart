import 'package:app/services/manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:intl/intl.dart';

class FitnessDashboardScreen extends StatefulWidget {
  @override
  _FitnessDashboardScreenState createState() => _FitnessDashboardScreenState();


}




class _FitnessDashboardScreenState extends State<FitnessDashboardScreen> {
  BackendManager manager=BackendManager();
  int _selectedIndex = 0;
  //String selectedCategory = "Lift for\nStrength";
  String selectedCategory = "";
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  

  //for the lift for strength situation
  Map<String, dynamic> strengthList = {};
  DocumentSnapshot? snap;

  //the done workouts are stored in a set
  Set<String> completedExercises = {};

 @override
void initState() {
  super.initState();
  this.selectedCategory="";
  initPage();
  
/*
if (manager.goal == "Gain muscle mass" || manager.goal == "Get stronger") {
    selectedCategory = 'Lift for Strength';
  } else if (manager.goal == "Keep fit") {
    selectedCategory = "keep fit";
  } else {
    selectedCategory = "Cardio";
  }
*/
  print("🔁 Initial category based on goal: $selectedCategory");

}




void initPage()async{

  await loadCompletedWorkouts();

  setState(() {
    print("loaded");
  });
}




//this func loads data and also saves it if the day ends , it syncs in weeklyprogress collection also
Future<void> loadCompletedWorkouts() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  final docRef = FirebaseFirestore.instance.collection('finishedWorkouts').doc(userId);
  final docSnap = await docRef.get();
  final data = docSnap.data();

  final today = DateTime.now();
  final todayLabel = DateFormat('EEE').format(today).toLowerCase(); // e.g., "fri"
  final todayStr = DateFormat('yyyy-MM-dd').format(today); // e.g., "2025-08-08"

  // Load weekly progress
  final weeklyDoc = await FirebaseFirestore.instance.collection("weeklyProgress").doc(userId).get();
  String? saved = weeklyDoc.data()?['lastSaved']?.toLowerCase(); // e.g., "thu"
  

  if (saved == null) {
      await FirebaseFirestore.instance.collection("weeklyProgress").doc(userId).set({
        'lastSaved': todayLabel
      }, SetOptions(merge: true));

      print("🧙‍♂️ Initialized lastSaved to $todayLabel");
      return; // Skip saving progress since there's no previous day
    }

  final savedLabel=saved;
  // Load completed workouts from Firebase
  List<String> loaded = List<String>.from(data?['completed'] ?? []);
  completedExercises = loaded.toSet();

  // 🧹 Check if it's a new day
  if (savedLabel != todayLabel) {
    // Save previous day's progress
    double progress = completedExercises.length.toDouble();

    await FirebaseFirestore.instance.collection("weeklyProgress").doc(userId).set({
      savedLabel: progress, // Save under today's label
      'lastSaved': todayLabel // Update last saved day
    }, SetOptions(merge: true));

    // Reset finishedWorkouts for the new day
    await docRef.set({
      'completed': [],
      'lastSaved': todayStr,
      'percentage': 0.0
    }, SetOptions(merge: true));

    setState(() {
      completedExercises.clear();
    });

    print("🌅 New day detected: saved progress and reset workouts.");
  } else {
    print("📅 Same day: no reset needed.");
  }
}




Future<DocumentSnapshot> getWorkoutForSelectedCategory() async {

  switch (selectedCategory) {
    case "Cardio\n ":
      {
        this.snap=null;
        this.strengthList.clear;
        return await getCardio();
        }
    case "Keep\nfit":
    { 
      this.snap=null;
      this.strengthList.clear; 
      return await getKeepFit();
    }
    case "Lift for\nStrength":
     { 
      return await getLiftForStrength("");
     }
    default:
        return FirebaseFirestore.instance.collection("workouts")
        .doc("default").collection("plans").doc("emptyDoc").get();   // ✅ Ensures future can handle null case
  }

  
}






// this widgets is the main and it calls the build of all this page elements, like the welcome 
////message and the category builder and daily plan card and the workout list that is imported from firebase
  @override
  Widget build(BuildContext context) {
    
    print("the very first selected category of page load is : $selectedCategory");
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),//to create the custom app bar
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            _buildWelcomeMessage(),
            SizedBox(height: 15),
           // _buildCalendarWidget(),
            SizedBox(height: 15),
            _buildCategorySelection(),
            SizedBox(height: 20),
            _buildDailyPlanCard(),
            SizedBox(height: 20),
            selectedCategory == "Lift for\nStrength"
            ? _buildWorkoutListliftforstrength(context)
            : _buildWorkoutList(context,snap),

            
          ],
        ),
      ),
      //bottomNavigationBar: _buildBottomNavBar(),
    );
  }



//the widget is an app bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal.shade300,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min, // Centers the content nicely
        children: [
          Text(
            "WorkOut",
            style: TextStyle(color: Colors.white),
          ),
          Icon(Icons.fitness_center, color: Colors.white),
          SizedBox(width: 8),
        ],
      ),
    );
  }




/////////////////////////////////////////////    THE WOELCOME MESSAGE 
  Widget _buildWelcomeMessage() {
    return Row(
      children: [
        Icon(Icons.fitness_center, color: Colors.deepPurple, size: 24),
        SizedBox(width: 8),
        Text(
          "Start your Workout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }



//////////////////////////////////////////////  THE BUILD CATEGORY
  Widget _buildCategorySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem("Cardio\n ", FontAwesomeIcons.personRunning),
        _buildCategoryItem("Lift for\nStrength", FontAwesomeIcons.dumbbell),
        _buildCategoryItem("Keep\nfit", FontAwesomeIcons.spa),
      ],
    );
  }




//THE ITEM FOR THE CATEGORY 
  Widget _buildCategoryItem(String title, IconData icon) {
   
    bool isSelected = selectedCategory == title;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
            if (title != "Lift for\nStrength") {
      snap = null; // 🧹 Clear the override snapshot
      strengthList.clear();

    }

            // IF A CATEGORY IS SELECTED  THEN THE CHOOSEN TITLE WILL BE THE CATERGOTY TITLE
          });
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.red.withValues(), blurRadius: 4)]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 24,
                  color: isSelected ? Colors.deepPurple : Colors.black),
              SizedBox(height: 5),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }




//////////////////////////////////////////  THE DAILY PLAN CARD 
///THIS ONE HAS THE ADVANCEMENT IN PERCENTAGE AND THE DONE / ALL WORKOUTS LIKE 1/7 (DONE 1 OF 7 WORKOUTS)
  Widget _buildDailyPlanCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade200, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 20, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text(
                      "My Plan For Today",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: "${this.completedExercises.length}/7 Complete",
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "Complete",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: this.completedExercises.length/7),
            duration: Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 8,
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  ),
                  Text(
                    "${(value * 100).toInt()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }




////////////////////////////////////   IMPORTING THE WORKOUTS FROM DB \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
///
///
///                                   THE GETTERS FOR PRESENTATION   
Future<DocumentSnapshot> getCardio() async{
    return FirebaseFirestore.instance.collection("workouts").doc("cardio").collection("plans")
      .doc("cardio_day").get(); // Plan data as a Map
}

Future<DocumentSnapshot> getKeepFit() async{
    return FirebaseFirestore.instance.collection("workouts").doc("keep_fit").collection("plans")
      .doc("keep_fit").get(); // Plan data as a Map
}



//HERE ARE FEW DOCS THAT CAN BE CHOOSEN FROM , WE PUT IT IN LIST AND THEN FOR EACH DAY WE CHOOSE RANDOMLY
Future<DocumentSnapshot> getLiftForStrength(String type) async{
    return FirebaseFirestore.instance.collection("workouts").doc("lift_for_strength").collection("plans")
      .doc("$type").get(); // Plan data as a Map
}







//the workout function that views all workout list in listview and make it clickable 
//to enter the workout info and click done

Widget _buildWorkoutList(BuildContext context, DocumentSnapshot? overrideSnapshot) {
Future<DocumentSnapshot> workoutFuture = 
  snap == null 
    ? getWorkoutForSelectedCategory() 
    : Future.value(snap);

  print("the snapshot is ${snap}");
  return FutureBuilder<DocumentSnapshot>(
    future: workoutFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
        return Center(child: Text("Please select a training category."));
      }

      Map<String, dynamic>? workoutData = snapshot.data!.data() as Map<String, dynamic>?;
      if (workoutData == null || workoutData.isEmpty) {
        return Center(child: Text("Workout data not found."));
      }

      List<dynamic> exercises = workoutData["exercises"] ?? [];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Plan Name: ${workoutData["name"]}", style: TextStyle(fontSize: 20)),
          Text("Duration: ${workoutData["duration"]} mins"),
          ...exercises.map<Widget>((exercise) => GestureDetector(
                onTap: () => _showExerciseDialog(context, exercise),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color.fromARGB(255, 176, 176, 176), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.fitness_center, color: Colors.deepPurple),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          exercise.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
              .toList(),
        ],
      );
    },
  );
}



//for lift for strength

Widget _buildWorkoutListforliftforstrength(BuildContext context) {
  return FutureBuilder<DocumentSnapshot?>(
    future: getWorkoutForSelectedCategory(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }
      if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
        return Center(child: Text("Please select a training category."));
      }
      Map<String, dynamic>? workoutData = snapshot.data?.data() as Map<String, dynamic>?;
      if (workoutData == null) {
        return Text("Workout data not found.");
      }
      return Column(
        children: [
          Text("Plan Name: ${workoutData["name"]}", style: TextStyle(fontSize: 20)),
          Text("Duration: ${workoutData["duration"]} mins"),
          ...workoutData["exercises"]
              .map<Widget>((exercise) => GestureDetector(
                    onTap: () => _showExerciseDialog(context, exercise),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),],
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color.fromARGB(255, 176, 176, 176), width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.fitness_center, color: Colors.deepPurple),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              exercise,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ],
      );
    },
  );
}





//WHEN CLICKING A WORKOUT A DIALOG THIS DIALOG WILL POP 
void _showExerciseDialog(BuildContext context, String exercise) {


  // 🧠 Preprocess the exercise name to match your asset file format
  String cleanedName = exercise.toLowerCase().replaceAll(' ', '');
  // 🎯 Build full path using category and file name
  String folderName = getCleanCategoryPath(selectedCategory);
  String imagePath = 'assets/gifs/$folderName/$cleanedName.gif';



  print("the image path is this one: $imagePath");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Exercise Detail"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 📸 Display the exercise GIF
            Image.asset(  imagePath,
            //if path not found view the blank gif instead
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/gifs/cardio/blankGif.gif");
                },
              ),

            SizedBox(height: 10),
            Text("Details for: $exercise"),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // handle "done" logic here, if clicked then increment this worjout and pop
                  if(completedExercises.length<=6)
                    {completedExercises.add(exercise);}
                    print("the length of workout now is : ${completedExercises.length}");
                  manager.trackWorkout(exercise); //in manager we sync progress with firebase
                  Navigator.of(context).pop();
                  setState(() {}); // refresh UI
                },
                child: Text("Done"),
              ),
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  
                  //just pop 
                  Navigator.of(context).pop();
                  
                },
              ),
            ],
          ),
        ],
      );
    },
  );


}



//the category folder, to get the image folder location
String getCleanCategoryPath(String category) {
  return category.toLowerCase().replaceAll('\n', '').replaceAll(' ', '');
}


//map names to easen the firebase lift for strength get
final Map<String, String> liftForStrengthDocMap = {
  "Chest Strength Training": "chest_day",
  "Power Leg Fire Sessions": "leg_day",
  "Back Training": "back_day",
  "Biceps Training": "biceps_day",
  "Triceps Training": "triceps_day",
  "Shoulder Training": "shoulder_day",
  "Full Body Power Workout": "full_body_day",
};


  final List<Map<String, dynamic>> workoutList = [
    {
      "title": "Chest Strength Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "953 kcal",
      "image":
          "https://cdn.muscleandstrength.com/sites/default/files/field/feature-image/workout/10mass_feature.jpg"
    },
    {
      "title": "Power Leg Fire Sessions",
      "duration": "1 Hour, 25 Minutes",
      "calories": "351 kcal",
      "image":
          "https://shop.bodybuilding.com/cdn/shop/articles/leg-workouts-for-men-get-thicker-quads-glutes-and-hams-986493.jpg?v=1737673309&width=900"
    },
    {
      "title": "Back Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://cdn.shopify.com/s/files/1/0816/2082/8435/files/Back_Cover_1024x1024.jpg?v=1707160835"
    },
    {
      "title": "Biceps Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://shop.bodybuilding.com/cdn/shop/articles/arm-workouts-for-men-to-build-bigger-biceps-822489.jpg?v=1731882647&width=900"
    },
    {
      "title": "Triceps Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://www.kettlebellkings.com/cdn/shop/articles/9ef303d8aa70a7750d93df68c947b645_6ad0537f-1b04-42d1-8131-a630f2cd5dc6.jpg?v=1739267183&width=900"
    },
    {
      "title": "Shoulder Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2023/05/shutterstock_336330470-scaled.jpg?resize=2048%2C1365&ssl=1"
    },
    {
      "title": "Full Body Power Workout",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://i0.wp.com/www.muscleandfitness.com/wp-content/uploads/2019/04/triceps-pushup-lean-muscular.jpg?w=940&h=529&crop=1&quality=86&strip=all"
    },
  ];




  Widget _buildWorkoutListliftforstrength(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Workout Programs",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: workoutList.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            final workout = workoutList[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    workout["image"],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(workout["title"],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "${workout["duration"]}  |  ${workout["calories"]}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                onTap: () async {
                  DocumentSnapshot snapshot = await getLiftForStrength(liftForStrengthDocMap[workout["title"]]!);
                  this.strengthList = snapshot.data() as Map<String, dynamic>;
                  this.snap=snapshot;
                 _showWorkoutDialog(context);



                },
              ),
            );
          },
        ),
      ],
    );
  }



 void _showWorkoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: SingleChildScrollView(
            child: _buildWorkoutList(context,snap),
          ),
        ),
      );
    },
  );
}

}