import 'package:app/services/manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
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
  

 @override
void initState() {
  super.initState();
  this.selectedCategory="";
  
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
  



Future<DocumentSnapshot> getWorkoutForSelectedCategory() async {

  switch (selectedCategory) {
    case "Cardio\n ":
      return await getCardio();
    case "Keep\nfit":
      return await getKeepFit();
    case "Lift for\nStrength":
      return await getLiftForStrength();
    default:
        return FirebaseFirestore.instance.collection("workouts")
        .doc("default").collection("plans").doc("emptyDoc").get();   // ✅ Ensures future can handle null case
  }
}

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




  @override
  Widget build(BuildContext context) {
    
    print("the very first selected category of page load is : $selectedCategory");
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
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
            _buildWorkoutList(context),
            
          ],
        ),
      ),
      //bottomNavigationBar: _buildBottomNavBar(),
    );
  }

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

  Widget _buildCalendarWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month - 1);
                });
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DateFormat('MMMM yyyy').format(_focusedDay),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month + 1);
                });
              },
            ),
          ],
        ),
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerVisible: false,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
                color: Colors.pink.shade100, shape: BoxShape.circle),
            selectedDecoration:
                BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
            weekendTextStyle: TextStyle(color: Colors.redAccent),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
            weekendStyle:
                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          calendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem("Cardio\n ", FontAwesomeIcons.running),
        _buildCategoryItem("Lift for\nStrength", FontAwesomeIcons.dumbbell),
        _buildCategoryItem("Keep\nfit", FontAwesomeIcons.spa),
      ],
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
   
    bool isSelected = selectedCategory == title;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
            
        
          });
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 4)]
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
                    text: "1/7 ",
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
            tween: Tween<double>(begin: 0, end: 0.25),
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
      .doc("peLX0fXhGs8KScLIiOhG").get(); // Plan data as a Map
}

Future<DocumentSnapshot> getKeepFit() async{
    return FirebaseFirestore.instance.collection("workouts").doc("keep_fit").collection("plans")
      .doc("46m5qqfM8BcpIRMu9Yl0").get(); // Plan data as a Map
}

Future<DocumentSnapshot> getLiftForStrength() async{
    return FirebaseFirestore.instance.collection("workouts").doc("cardio").collection("plans")
      .doc("peLX0fXhGs8KScLIiOhG").get(); // Plan data as a Map
}







//the workout function that views all workout list in listview and make it clickable 
//to enter the workout info and click done


Widget _buildWorkoutList(BuildContext context) {
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

void _showExerciseDialog(BuildContext context, String exercise) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Exercise Detail"),
        content: Text("Details for: $exercise"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(onPressed: (){},child: Text("Done"),),
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
          
        ],
      );
    },
  );
}






  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            // Update state here as needed
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          elevation: 10,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: "Favorites"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined), label: "Activity"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: "Settings"),
          ],
        ),
      ),
    );
  }
}