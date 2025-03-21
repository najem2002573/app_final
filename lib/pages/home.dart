import 'package:flutter/material.dart';
import 'package:app/pages/food.dart';
import 'package:app/pages/health.dart'; // Ensure this is the correct path
import 'package:app/pages/workout.dart'; // Ensure this is the correct path
import 'package:app/pages/calories.dart'; // Ensure this is the correct path
import 'package:app/pages/settings.dart'; // Ensure this is the correct path
import 'package:fl_chart/fl_chart.dart';
//last version
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // To keep track of the selected index and corresponding page
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePageContent(),
    Calories(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // Show the page based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the current index
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the index when an icon is clicked
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: _selectedIndex == 0 ? Colors.green : Colors.grey[800]),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copyright, color: _selectedIndex == 1 ? Colors.green : Colors.black),
            label: "Calories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: _selectedIndex == 2 ? Colors.green : Colors.black),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics, color: _selectedIndex == 2 ? Colors.green : Colors.black),
            label: "gyms",
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Navbar color
        selectedItemColor: Colors.green, // Color of the selected icon
        unselectedItemColor: Colors.black, // Color of unselected icons
      ),
    );
  }
}

// A dummy content page for Home
class HomePageContent extends StatelessWidget {
  final List<double> weeklyStats = [3, 4, 2, 5, 8, 5, 3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EVERYDAY WE'RE MUSCLEN",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Hello, Alex 👋",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildMyPlanSection(context),
                const SizedBox(height: 20),
                _buildProbabilityChart(75),
                const SizedBox(height: 20),
                _buildWeeklyStats(),
                const SizedBox(height: 20),
                _buildMotivationalMovies(),
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
            _buildPlanCardworkout("Workout", "2 hours", Icons.fitness_center, Colors.purple.shade100, context),
            const SizedBox(width: 10),
            _buildPlanCardhealth("Health", "", Icons.heart_broken, Colors.grey.shade200, context),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildPlanCardfood("Food", "1832 kcal", Icons.restaurant, Colors.white, context, border: true),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
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




          //workoutcard
Widget _buildPlanCardworkout(String title, String subtitle, IconData icon, Color color,BuildContext context, {bool border = false}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FitnessDashboardScreen()), // Navigate to WorkoutPage
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: border ? Border.all(color: Colors.black) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    ),
  );
}


//food card
  Widget _buildPlanCardfood(String title, String subtitle, IconData icon, Color color, BuildContext context, {bool border = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Food()), // Navigate to your HealthPage
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: border ? Border.all(color: Colors.black) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildPlanCardhealth(String title, String subtitle, IconData icon, Color color, BuildContext context, {bool border = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HealthPage()), // Navigate to your HealthPage
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: border ? Border.all(color: Colors.black) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Similar changes can be made to the other plan cards (_buildPlanCardworkout, _buildPlanCardfood)
  // I am skipping repeating those parts for brevity.
  
  Widget _buildProbabilityChart(double probability) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Success Probability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Center(
              child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 15.0,
                    value: 0.65,
                    backgroundColor: Colors.white,
                    color: Colors.purple.shade300,
                  ),
                  Center(child: Text("65%", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),),
            )
          ],
        ),
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
          barGroups: List.generate(7, (index) => _buildBar(weeklyStats[index], index == 4)),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt()],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
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
            : [Colors.greenAccent,Colors.purple.shade300],
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



  Widget _buildMotivationalMovies() {
    List<Map<String, String>> movies = [
      {
        "title": "Rocky",
        "image": "https://upload.wikimedia.org/wikipedia/en/1/18/Rocky_poster.jpg"
      },
      {
        "title": "Creed",
        "image": "https://upload.wikimedia.org/wikipedia/en/2/24/Creed_poster.jpg"
      },
      {
        "title": "The Karate Kid",
        "image": "https://upload.wikimedia.org/wikipedia/en/a/a9/Karate_kid.jpg"
      },
      {
        "title": "Million Dollar Baby",
        "image": "https://upload.wikimedia.org/wikipedia/en/d/d3/Million_Dollar_Baby_poster.jpg"
      }
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Motivational Movies",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 300,
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                      child: Image.network(
                        movies[index]["image"]!,
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          movies[index]["title"]!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }


