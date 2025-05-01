import 'dart:io';

import 'package:app/pages/gymspage.dart';
import 'package:app/services/appUser.dart';
import 'package:app/services/manager.dart';
import 'package:app/services/nutrients.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/food.dart';
import 'package:app/pages/health.dart'; // Ensure this is the correct path
import 'package:app/pages/workout.dart'; // Ensure this is the correct path
import 'package:app/pages/calories.dart'; // Ensure this is the correct path
import 'package:app/pages/settings.dart'; // Ensure this is the correct path
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

//last version
class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
  
}

final manager=BackendManager();

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  

  @override
  void initState() {
    // TODO: implement initState
    manager.loadUserData();
    
  }

  Box b=Hive.box<AppUser>('userBox');
  
  


  //get the real user name to print it in the welcome user placeholder
  
  final List<Widget> _pages = [
    HomePageContent(),
    Gymspage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    AppUser user=b.get('currentUser');
    print("the user loaded from the local cache is : ${user.username} and printed in the widget in home page");
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
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
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_pin),
              label: "Gyms",

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: "Settings",
            ),
            
          ],
        ),
      ),
    );
  }
}

// A dummy content page for Home
class HomePageContent extends StatefulWidget {

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final List<double> weeklyStats = [3, 4, 2, 5, 8, 5, 3];
  String profileImagePAth="";
  double probability=0;

 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Box profileImage=Hive.box('profileimageBox');
    profileImagePAth=profileImage.get('profileimage') ?? "";

  }
  @override
  Widget build(BuildContext context) {
    BackendManager manager=BackendManager();
    
    //getting the user name from the Hive
       final box=Hive.box<AppUser>('userBox');
       final user = box.get('currentUser');
       final userName = user?.username ?? 'Guest';
       print('the new username from the login is ${userName}');
    
   return Scaffold(
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // added for alignment
                  children: [
                    const Text(
                      "EVERYDAY WE'RE MUSCLEN",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    // const SizedBox(height: 4),
                    Text(
                      "  Hello, ${userName} 👋",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.pink.shade50,
                  child: CircleAvatar(
                    radius: 28, // adjusted to fit inside properly
                   backgroundImage: profileImagePAth.isNotEmpty
  ? FileImage(File(profileImagePAth))   // ✅ Load image from file
  : null,   // ✅ Use default image if path is empty,// Replace later
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildMyPlanSection(context),
            const SizedBox(height: 20),
            buildSuccessProbabilityCard(),
            const SizedBox(height: 20),
            _buildWeeklyStats(),
            const SizedBox(height: 20),
            _buildMotivationalMusic(),
          ],
        ),
      ),
    ),
  ),
);

  
  }

  Widget _buildMyPlanSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Plan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPlanCardworkout("WorkOut", "2 hours", Icons.fitness_center,
                Colors.purple.shade100, context),
            const SizedBox(width: 10),
            _buildPlanCardhealth("Health", "", Icons.heart_broken,
                Colors.grey.shade200, context),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPlanCardfood(
                "Food", "1832 kcal", Icons.restaurant, Colors.white, context,
                border: true),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  //manager.testHive();
                  //test the uid
                  print("now deleting managers nutrients");
                  await manager.deleteNutrients();
                  Box box=Hive.box<Nutrients>('nutrientsBox');
                            print(box.keys);  // will list all keys
          print(box.values);  // will show all values


                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Let's Go"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCardworkout(String title, String subtitle, IconData icon,
      Color color, BuildContext context,
      {bool border = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FitnessDashboardScreen()),
          );
        },
        child: Container(
          margin: EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            border: border ? Border.all(color: Colors.black) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(icon, color: Colors.black, size: 20),
                radius: 18,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCardfood(String title, String subtitle, IconData icon,
      Color color, BuildContext context,
      {bool border = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DailyDietPage()),
          );
        },
        child: Container(
          margin: EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            border: border ? Border.all(color: Colors.black) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(icon, color: Colors.black, size: 20),
                radius: 18,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCardhealth(String title, String subtitle, IconData icon,
      Color color, BuildContext context,
      {bool border = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HealthPage()),
          );
        },
        child: Container(
          margin: EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            border: border ? Border.all(color: Colors.black) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(icon, color: Colors.black, size: 20),
                radius: 18,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget buildSuccessProbabilityCard() {
     double probability=0;
     
     manager.getPrediction;
     print("invoking manager goal predictions");
     probability=manager.successProba;
     print("the proba is $probability");
     
    print("the proba got from the goal ml model is : $probability");
    return Container(
      width: 500,
      height: 206,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade100, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart_rounded, color: Colors.deepPurple),
              SizedBox(width: 6),
              Text(
                "Success Probability",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CircularPercentIndicator(
            radius: 65.0,
            lineWidth: 10.0,
            animation: true,
            animationDuration: 800,
            percent: probability,
            center: Text(
              "${(probability * 100).toInt()}%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.deepPurple,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.grey.shade200,
            progressColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weekly Stats",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          height: 170,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: BarChart(
            BarChartData(
              barGroups: List.generate(
                  7, (index) => _buildBar(weeklyStats[index], index == 4)),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      List<String> days = [
                        "Mon",
                        "Tue",
                        "Wed",
                        "Thu",
                        "Fri",
                        "Sat",
                        "Sun"
                      ];
                      return Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          days[value.toInt()],
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBar(double value, bool highlight) {
    return BarChartGroupData(
      x: weeklyStats.indexOf(value),
      barRods: [
        BarChartRodData(
          toY: value,
          gradient: LinearGradient(
            colors: highlight
                ? [Colors.greenAccent, Colors.blueAccent]
                : [Colors.greenAccent, Colors.purple.shade300],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 20,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10, // Max Value
            color: Colors.grey.shade200,
          ),
        )
      ],
    );
  }
}

Widget _buildMotivationalMusic() {
  
  List<Map<String, String>> musicList = [
    {
      "title": "Eye of the Tiger",
      "artist": "Survivor",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl7kztrZfASzd0Wqc-yEPLXYvn1i9Lq2eFsA&s"
    },
    {
      "title": "Stronger",
      "artist": "Kanye West",
      "image":
          "https://i.discogs.com/7HgqlxY5-5Z-JE8mDWXCoUWYB08NW0rj3IdrnDOSs8o/rs:fit/g:sm/q:90/h:526/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTU3NjU1/ODQtMTQ5ODMwMjAx/Ny03ODY2LmpwZWc.jpeg"
    },
    {
      "title": "Lose Yourself",
      "artist": "Eminem",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5m80Y6CLaXt4CvNTSvsMREuvrMV5AoAmLgw&s"
    },
    {
      "title": "Till I Collapse",
      "artist": "Eminem ft. Nate Dogg",
      "image":
          "https://i1.sndcdn.com/artworks-000161139232-rkikne-t1080x1080.jpg"
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "🎧 Motivational Music",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: musicList.length,
          itemBuilder: (context, index) {
            final music = musicList[index];
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 700 + index * 100),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                width: 220,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade100, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        music["image"]!,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            music["title"]!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            music["artist"]!,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.play_circle_fill,
                                  color: Colors.deepPurple, size: 24),
                              SizedBox(width: 6),
                              Text("Play",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.deepPurple)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}