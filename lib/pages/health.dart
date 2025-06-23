import 'package:app/pages/food.dart';
import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthPage extends StatefulWidget {
  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  BackendManager manager = BackendManager();

  String colesterol = "";

  double userWeight = 0;
  double userCalories = 0;
  double userBMI = 22.5;
  bool isMale = true;
  double sugarIntake = 0;
  double muscleMass = 0;

  double get bodyFatPercentage =>
      isMale ? (18 + 6) : (25 + 6); // Men: 18-24%, Women: 25-31%

  @override
  void initState() {
    super.initState();
    manager.loadUserData();
    double weight = manager.WEIGHT;
    double height = manager.HEIGHT;
    this.userWeight = weight;
    this.userCalories = manager.todayNutrints.calories;
    this.userBMI = weight / (height * height / 10000);
    this.muscleMass = weight - (weight * (1.2 * userBMI / 100)) * 0.8;
    this.sugarIntake = manager.todayNutrints.calories / 4;

    if (manager.age < 20)
      this.colesterol = "170";
    else
      this.colesterol = "200";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade400,
        elevation: 2,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: Colors.white),
            SizedBox(width: 8),
            Text("Health Summary", style: TextStyle(color: Colors.white)),
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
                children: [
                  _buildHealthCard('Cholesterol', '$colesterol mg/dL',
                      Icons.medical_services, Colors.orange.shade200, ""),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildHealthCard('Weight', '$userWeight kg',
                      Icons.monitor_weight, Colors.yellow.shade200, ""),
                  SizedBox(width: 8),
                  _buildHealthCard(
                      'BMI',
                      '${userBMI.toStringAsFixed(1)}',
                      Icons.bar_chart,
                      Colors.green.shade200,
                      ""),
                ],
              ),
              SizedBox(height: 20),
              Text('Additional Health Metrics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildHealthCard(
                      "Body Fat",
                      "${bodyFatPercentage.toStringAsFixed(1)}%",
                      Icons.percent,
                      Colors.purple.shade200,
                      ""),
                  SizedBox(width: 8),
                  _buildHealthCard(
                      "Sugar Intake",
                      "${sugarIntake.toStringAsFixed(1)} g",
                      Icons.cake,
                      Colors.pink.shade200,
                      ""),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildHealthCard(
                      "Muscle Mass",
                      "${muscleMass.toStringAsFixed(1)} kg",
                      Icons.fitness_center,
                      Colors.blue.shade200,
                      ""),
                ],
              ),
              SizedBox(height: 30),
              _buildComparisonTable(),
              SizedBox(height: 30),
              buildBodyCompositionChart()
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
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: Offset(2, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 26, color: Colors.black87),
            SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (suggestion.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  suggestion,
                  style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
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
      idealWeight = isMale ? '70–80' : '60–70';
      idealBMI = '18.5–24.9';
      idealBodyFat = isMale ? '18–24' : '25–31';
      idealMuscleMass = isMale ? '50–60' : '40–50';
    }

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
        _buildComparisonRow("Weight", "${userWeight.toStringAsFixed(1)} kg",
            idealWeight + " kg", getColor('weight', userWeight)),
        _buildComparisonRow("BMI", "${userBMI.toStringAsFixed(1)}", idealBMI,
            getColor('bmi', userBMI)),
        _buildComparisonRow(
            "Body Fat",
            "${bodyFatPercentage.toStringAsFixed(1)} %",
            idealBodyFat + "%",
            getColor('fat', bodyFatPercentage)),
        _buildComparisonRow(
            "Muscle Mass",
            "${muscleMass.toStringAsFixed(1)} kg",
            idealMuscleMass + " kg",
            getColor('muscle', muscleMass)),
      ],
    );
  }

  Widget _buildComparisonRow(
      String label, String userVal, String idealVal, Color valueColor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 14))),
          Expanded(
            child: Text(userVal,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: valueColor)),
          ),
          Expanded(
            child: Text(idealVal,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13, color: Colors.green.shade700)),
          ),
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
        color: Color(0xFF1C2331),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Body Composition Overview in Kg",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                maxY: 80,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        if (value % 5 != 0) return Container();
                        return Text('${value.toStringAsFixed(0)}',
                            style: TextStyle(color: Colors.grey[400], fontSize: 12));
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