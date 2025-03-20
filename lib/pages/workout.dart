import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class FitnessDashboardScreen extends StatefulWidget {
  @override
  _FitnessDashboardScreenState createState() => _FitnessDashboardScreenState();
}

class _FitnessDashboardScreenState extends State<FitnessDashboardScreen> {
  int _selectedIndex = 0; // Default active tab

  // *NEW: Added category selection state*
  String selectedCategory = "Lift for\nStrength"; // Default selected category

  final List<Map<String, dynamic>> workoutList = [
    {
      "title": "Chest Strength Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "953 kcal",
      "image": "https://cdn.muscleandstrength.com/sites/default/files/field/feature-image/workout/10mass_feature.jpg"
    },
    {
      "title": "Power Leg Fire Sessions",
      "duration": "1 Hour, 25 Minutes",
      "calories": "351 kcal",
      "image": "https://shop.bodybuilding.com/cdn/shop/articles/leg-workouts-for-men-get-thicker-quads-glutes-and-hams-986493.jpg?v=1737673309&width=900"
    },
    {
      "title": "Back Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image": "https://cdn.shopify.com/s/files/1/0816/2082/8435/files/Back_Cover_1024x1024.jpg?v=1707160835"
    },
    {
      "title": "Biceps Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image": "https://shop.bodybuilding.com/cdn/shop/articles/arm-workouts-for-men-to-build-bigger-biceps-822489.jpg?v=1731882647&width=900"
    },
    {
      "title": "Triceps Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image": "https://www.kettlebellkings.com/cdn/shop/articles/9ef303d8aa70a7750d93df68c947b645_6ad0537f-1b04-42d1-8131-a630f2cd5dc6.jpg?v=1739267183&width=900"
    },
    {
      "title": "Shoulder Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image": "https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2023/05/shutterstock_336330470-scaled.jpg?resize=2048%2C1365&ssl=1"
    },
    {
      "title": "Full Body Power Workout",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image": "https://i0.wp.com/www.muscleandfitness.com/wp-content/uploads/2019/04/triceps-pushup-lean-muscular.jpg?w=940&h=529&crop=1&quality=86&strip=all"
    },
  ];

  final List<Map<String, String>> dailyTasks = [
    {"title": "Morning Yoga", "time": "15 min", "calories": "100 cal"},
    {"title": "HIIT Workout", "time": "30 min", "calories": "250 cal"},
  ];

  @override
  Widget build(BuildContext context) {
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
            _buildCategorySelection(),
            SizedBox(height: 20),
            _buildDailyPlanCard(),
            SizedBox(height: 20),
            _buildWorkoutList(),
            SizedBox(height: 20),
            //_buildDailyTasks(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Text(
            "👋 Alex",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Text(
      "Start your Workout",
      style: TextStyle(fontSize: 16, color: Colors.grey.shade700), 
    );
  }

  // *Updated Category Selection*
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
            selectedCategory = title; // Update selected category
          });
        },
        child: Container(
          
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.red.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 4)] : [],
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: isSelected ? Colors.red : Colors.black),
              SizedBox(height: 5),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyPlanCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Plan For Today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("1/7 Complete", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.25,
                  backgroundColor: Colors.white,
                  color: Colors.purple,
                ),
                Center(child: Text("25%", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Workout Programs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: workoutList.map((workout) {
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(workout["image"], width: 100, height: 100, fit: BoxFit.cover),
                ),
                title: Text(workout["title"], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${workout["duration"]}  |  ${workout["calories"]}"),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Activity"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}


/*
 final List<Map<String, String>> dailyTasks = [
    {"title": "Morning Yoga", "time": "15 min", "calories": "100 cal"},
    {"title": "HIIT Workout", "time": "30 min", "calories": "250 cal"},
  ];

Widget _buildDailyTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Column(
          children: dailyTasks.map((task) {
            return ListTile(
              leading: CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.play_arrow, color: Colors.white)),
              title: Text(task["title"]!),
              subtitle: Text("${task["time"]}  |  ${task["calories"]}"),
            );
          }).toList(),
        ),
      ],
    );
  }
  */