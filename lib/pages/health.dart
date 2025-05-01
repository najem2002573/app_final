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
                  _buildHealthCard('Heart Rate', '97 bpm', Icons.favorite,
                      Colors.blue.shade100, ""),
                  _buildHealthCard('Cholesterol', '180 mg/dL',
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
              Text("Weekly Muscle & Fat Trends",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                height: 280,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF1C2331),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: BarChart(
                  BarChartData(
                    maxY: 12,
                    barGroups: _barGroups(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}K',
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 12));
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              'Mn',
                              'Te',
                              'Wd',
                              'Tu',
                              'Fr',
                              'St',
                              'Sn'
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(days[value.toInt()],
                                  style: TextStyle(color: Colors.grey[400])),
                            );
                          },
                        ),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        //  tooltipBgColor: Colors.white,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                              '${rod.toY.toStringAsFixed(1)}K',
                              TextStyle(color: Colors.black));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
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