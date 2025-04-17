import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Constants for calculations
const double userWeight = 68; // kg
const double userCalories = 2500; // kcal per day
const double userBMI = 22.5;
const bool isMale = true; // Change to false for female

// Calculations
double get bodyFatPercentage =>
    isMale ? (18 + 6) : (25 + 6); // Men: 18-24%, Women: 25-31%
double get sugarIntake => userCalories / 4; // Sugar in grams
double get muscleMass =>
    (userWeight - (userWeight * (1.20 * userBMI / 100))) * 0.80;

class HealthPage extends StatelessWidget {
  final manager=BackendManager();
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
                  _buildHealthCard('Weight', '68 kg', Icons.monitor_weight,
                      Colors.yellow.shade100, ""),
                  _buildHealthCard('BMI', '22.5', Icons.bar_chart,
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
    final comparisonData = [
      {'label': 'Weight', 'userValue': '90 kg', 'idealValue': '68–75 kg'},
      {'label': 'BMI', 'userValue': '29.4', 'idealValue': '18.5–24.9'},
      {
        'label': 'Body Fat',
        'userValue': '28%',
        'idealValue': isMale ? '18–24%' : '25–31%'
      },
      {'label': 'Muscle Mass', 'userValue': '45 kg', 'idealValue': '50–60 kg'},
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