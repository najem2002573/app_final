
/*

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
          ...workoutData["exercises"].map<Widget>((exercise) => ListTile(title: Text(exercise))).toList(),
        ],
      );
    },
  );
}



the new design: better version



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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepPurpleAccent, width: 1.2),
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
          TextButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

*/





/*
old update data page

import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';

class Updatedata extends StatefulWidget {
  const Updatedata({super.key});

  @override
  State<Updatedata> createState() => _UpdatedataState();
}

class _UpdatedataState extends State<Updatedata> {
  BackendManager manager = BackendManager(); // Singleton Manager instance
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController(); // Age Controller

  // List of fitness goals
  final List<String> fitnessGoals = [
    "Lose Weight",
    "Keep Fit",
    "Lift for Strength & Gain Muscle Mass"
  ];

  // Selected fitness goal
  String selectedGoal = "Lose Weight";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Health Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weight Input Box
            Text("Enter Your Weight (kg):"),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter weight",
              ),
            ),
            SizedBox(height: 16),

            // Height Input Box
            Text("Enter Your Height (cm):"),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter height",
              ),
            ),
            SizedBox(height: 16),

            // Age Input Box
            Text("Enter Your Age:"),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter age",
              ),
            ),
            SizedBox(height: 16),

            // Fitness Goals Dropdown
            Text("Select Your Fitness Goal:"),
            DropdownButton<String>(
              value: selectedGoal,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGoal = newValue!;
                });
              },
              items: fitnessGoals.map<DropdownMenuItem<String>>((String goal) {
                return DropdownMenuItem<String>(
                  value: goal,
                  child: Text(goal),
                );
              }).toList(),
            ),
            SizedBox(height: 24),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save input values
                  String weight = weightController.text;
                  String height = heightController.text;
                  String age = ageController.text; // Read age input
                  manager.getPrediction();
                  print(
                      "Saved Data - Weight: $weight, Height: $height, Age: $age, Goal: $selectedGoal");

                  if (weight.isNotEmpty &&
                      height.isNotEmpty &&
                      age.isNotEmpty) {
                    // Update manager with user inputs
                    manager.setHeight(double.parse(height));
                    manager.setWeight(double.parse(weight));
                    manager.setAge(int.parse(age)); // Set age
                    manager.setGoal(selectedGoal);
                    
                    manager.createLocalUserData(); // Local storage logic
                    manager.uploadUserDataToFirebase(); // Firebase upload logic
                    _showSuccessUpdatSnackBar("Updated Data Successfully!.",Colors.green);
                    Navigator.pop(context);
                  } else {
                    print("Error: Some fields are empty.");
                    _showSuccessUpdatSnackBar("Failed to update",Colors.red);
                  }
                },
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showSuccessUpdatSnackBar(String title,Color color){
   ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(title),
          duration: Duration(seconds: 2),
          backgroundColor: color,
        ),
      );
  }
}





the health page graph weeekly trends
  Widget _buildComparisonTable() {
  String goal=manager.goal;

  String idealWeight = '';
  String idealBMI = '';
  String idealBodyFat = '';
  String idealMuscleMass = '';

  // Adjust ideal values based on user goal
  if (goal == "Lift for Strength" || goal=="Gain Muscle Mass") {
    idealWeight = isMale ? '75–90 kg' : '65–80 kg';
    idealBMI = '25–29.9'; // Higher BMI due to increased muscle mass
    idealBodyFat = isMale ? '12–18%' : '18–22%'; // Lower fat for strength
    idealMuscleMass = isMale ? '60–70 kg' : '50–60 kg'; // Higher muscle density
  } else if (goal == "Lose Weight") {
    idealWeight = isMale ? '65–75 kg' : '55–65 kg';
    idealBMI = '18.5–24.9'; // Healthy BMI range
    idealBodyFat = isMale ? '15–20%' : '20–25%'; // Focus on fat reduction
    idealMuscleMass = isMale ? '50–60 kg' : '40–50 kg'; // Maintain balanced muscle mass
  } else if (goal == "Keep Fit") {
    idealWeight = isMale ? '70–80 kg' : '60–70 kg';
    idealBMI = '18.5–24.9'; // Maintain healthy BMI range
    idealBodyFat = isMale ? '18–24%' : '25–31%'; // Maintenance fat levels
    idealMuscleMass = isMale ? '50–60 kg' : '40–50 kg'; // Balanced muscle levels
  }

  // Comparison data table
  var comparisonData = [
    {'label': 'Weight', 'userValue': '${userWeight}', 'idealValue': idealWeight},
    {'label': 'BMI', 'userValue': '${userBMI.toStringAsFixed(1)}', 'idealValue': idealBMI},
    {'label': 'Body Fat', 'userValue': '${bodyFatPercentage} %', 'idealValue': idealBodyFat},
    {'label': 'Muscle Mass', 'userValue': '${muscleMass.toStringAsFixed(2)}', 'idealValue': idealMuscleMass},
  ];


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Comparison Table",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
          ),
          child: Column(
            children: comparisonData.map((row) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(row['label']!,
                            style: TextStyle(fontSize: 14))),
                    Expanded(
                        child: Text(row['userValue']!,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text(row['idealValue']!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.green.shade700))),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }







the bar group for weekly chart comparison



  List<BarChartGroupData> _barGroups() {
    final teal = Colors.cyanAccent;
    final pink = Colors.pinkAccent;
    final data = [
      [2.5, 5.5],
      [6.2, 5.9],
      [3.0, 9.8],
      [1.0, 9.5],
      [9.5, 9.5],
      [2.0, 10.0],
      [1.5, 4.5],
    ];
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
              toY: data[index][0],
              color: teal,
              width: 7,
              borderRadius: BorderRadius.circular(4)),
          BarChartRodData(
              toY: data[index][1],
              color: pink,
              width: 7,
              borderRadius: BorderRadius.circular(4)),
        ],
        barsSpace: 4,
      );
    });
  }
}







the health full page 100%%% working



import 'package:app/pages/food.dart';
import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Constants for calculations

class HealthPage extends StatefulWidget {
  
  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {

  
  BackendManager manager=BackendManager();

  String colesterol="";
  
   double 
 userWeight = 0;
 // kg
 double userCalories=0; 
 // kcal per day
 double userBMI = 22.5;

 bool isMale = true; 
 // Change to false for female
double get bodyFatPercentage =>
    isMale ? (18 + 6) : (25 + 6); 
 // Men: 18-24%, Women: 25-31%
double  sugarIntake =0;
 // Sugar in grams
double  muscleMass =0;
    

@override
void initState() {
    // TODO: implement initState
    super.initState();
    
    manager.loadUserData();
    double weight=manager.WEIGHT;
    double height=manager.HEIGHT;
    this.userWeight=weight;
    this.userCalories=manager.todayNutrints.calories;
    this.userBMI=weight/(height*height/10000);
    this.muscleMass=weight-(weight*(1.2*userBMI/100))*0.8;
    this.sugarIntake=manager.todayNutrints.calories/4;

    if (manager.age<20)
      this.colesterol="170";
    else
      this.colesterol="200";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min, // Centers the content nicely
          children: [
            Text(
              "Health",
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.heart_broken, color: Colors.white),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
          
                  _buildHealthCard('Cholesterol', '${this.colesterol} mg/dL',
                      Icons.medical_services, Colors.orange.shade100, ""),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHealthCard('Weight', '${this.userWeight}', Icons.monitor_weight,
                      Colors.yellow.shade100, ""),
                  _buildHealthCard('BMI', '${this.userBMI.toStringAsFixed(1)}', Icons.bar_chart,
                      Colors.green.shade100, ""),
                ],
              ),
              SizedBox(height: 20),
              Text('Additional Health Metrics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHealthCard(
                      "Body Fat",
                      "${bodyFatPercentage.toStringAsFixed(1)}%",
                      Icons.percent,
                      Colors.purple.shade100,
                      ""),
                  _buildHealthCard(
                      "Sugar Intake",
                      "${sugarIntake.toStringAsFixed(1)} g",
                      Icons.cake,
                      Colors.pink.shade100,
                      ""),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHealthCard(
                      "Muscle Mass",
                      "${muscleMass.toStringAsFixed(1)} kg",
                      Icons.fitness_center,
                      Colors.blue.shade100,
                      ""),
                ],
              ),
              SizedBox(height: 30),
              _buildComparisonTable(),
              SizedBox(height: 30),
         

              SizedBox(height: 10),
             buildBodyCompositionChart()            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(String title, String value, IconData icon,
      Color color, String suggestion) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (suggestion.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  suggestion,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

Widget _buildComparisonTable() {
  String goal = manager.goal;

  String idealWeight = '';
  String idealBMI = '';
  String idealBodyFat = '';
  String idealMuscleMass = '';

  // Ideal values based on goal
  if (goal == "Lift for Strength" || goal == "Gain Muscle Mass") {
    idealWeight = isMale ? '75–90' : '65–80';
    idealBMI = '25–29.9';
    idealBodyFat = isMale ? '12–18' : '18–22';
    idealMuscleMass = isMale ? '60–70' : '50–60';
  } else if (goal == "Lose Weight") {
    idealWeight = isMale ? '65–75' : '55–65';
    idealBMI = '18.5–24.9';
    idealBodyFat = isMale ? '15–20' : '20–25';
    idealMuscleMass = isMale ? '50–60' : '40–50';
  } else {
    // Keep Fit
    idealWeight = isMale ? '70–80' : '60–70';
    idealBMI = '18.5–24.9';
    idealBodyFat = isMale ? '18–24' : '25–31';
    idealMuscleMass = isMale ? '50–60' : '40–50';
  }

  // Helper to get color based on comparison
  Color getColor(String type, double value) {
    List<String> range = [];
    if (type == 'weight') range = idealWeight.split('–');
    if (type == 'bmi') range = idealBMI.split('–');
    if (type == 'fat') range = idealBodyFat.replaceAll('%', '').split('–');
    if (type == 'muscle') range = idealMuscleMass.split('–');

    double min = double.tryParse(range[0]) ?? 0;
    double max = double.tryParse(range[1]) ?? double.infinity;

    if (value >= min && value <= max) return Colors.green.shade700;
    if ((value < min && value >= min - 3) || (value > max && value <= max + 3)) {
      return Colors.orange.shade600;
    }
    return Colors.red.shade600;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Comparison Table",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
        ),
        child: Column(
          children: [
            _buildComparisonRow(
              "Weight",
              "${userWeight.toStringAsFixed(1)} kg",
              idealWeight + " kg",
              getColor('weight', userWeight),
            ),
            _buildComparisonRow(
              "BMI",
              "${userBMI.toStringAsFixed(1)}",
              idealBMI,
              getColor('bmi', userBMI),
            ),
            _buildComparisonRow(
              "Body Fat",
              "${bodyFatPercentage.toStringAsFixed(1)} %",
              idealBodyFat + "%",
              getColor('fat', bodyFatPercentage),
            ),
            _buildComparisonRow(
              "Muscle Mass",
              "${muscleMass.toStringAsFixed(1)} kg",
              idealMuscleMass + " kg",
              getColor('muscle', muscleMass),
            ),
          ],
        ),
      ),
    ],
  );
}

// Helper widget to build each row
Widget _buildComparisonRow(String label, String userVal, String idealVal, Color valueColor) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: 14))),
        Expanded(
            child: Text(userVal,
                style: TextStyle(fontWeight: FontWeight.bold, color: valueColor))),
        Expanded(
            child: Text(idealVal,
                style: TextStyle(fontSize: 13, color: Colors.green.shade700))),
      ],
    ),
  );
}





Widget buildBodyCompositionChart() {
  final teal = Colors.cyanAccent;
  final pink = Colors.pinkAccent;

  final data = [
    [muscleMass, (bodyFatPercentage / 100) * userWeight],
  ];

  List<BarChartGroupData> barGroups = List.generate(data.length, (index) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: data[index][0],
          color: teal,
          width: 7,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: data[index][1],
          color: pink,
          width: 7,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      barsSpace: 4,
    );
  });

  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Color(0xFF1C2331), // Same deep background as your other chart
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Body Composition Overview in Kg",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              maxY: 80, // Adjust based on expected upper bound
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) {
                      if (value % 5 != 0) return Container();
                      return Text(
                        '${value.toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              barGroups: barGroups,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.square, color: teal, size: 16),
            SizedBox(width: 4),
            Text("Muscle Mass", style: TextStyle(color: Colors.white)),
            SizedBox(width: 16),
            Icon(Icons.square, color: pink, size: 16),
            SizedBox(width: 4),
            Text("Fat Mass", style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    ),
  );
}

}

*/

 