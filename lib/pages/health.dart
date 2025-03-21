import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Constants for calculations
const double userWeight = 68; // kg
const double userCalories = 2500; // kcal per day
const double userBMI = 22.5;
const bool isMale = true; // Change to false for female

// Calculations
double get bodyFatPercentage => isMale ? (18 + 6) : (25 + 6); // Men: 18-24%, Women: 25-31%
double get sugarIntake => userCalories / 4; // Sugar in grams
double get muscleMass => (userWeight - (userWeight * (1.20 * userBMI / 100))) * 0.80;

class HealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Dashboard'),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHealthCard('Heart Rate', '97 bpm', Icons.favorite, Colors.blue.shade100, ""),
                _buildHealthCard('Cholesterol', '180 mg/dL', Icons.medical_services, Colors.orange.shade100, ""),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHealthCard('Weight', '68 kg', Icons.monitor_weight, Colors.yellow.shade100, ""),
                _buildHealthCard('BMI', '22.5', Icons.bar_chart, Colors.green.shade100, ""),
              ],
            ),
            SizedBox(height: 20),
            
            // *NEW: Added Health Metrics*
            Text('Additional Health Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHealthCard(
                    "Body Fat", "${bodyFatPercentage.toStringAsFixed(1)}%", Icons.percent, Colors.purple.shade100, ""),
                _buildHealthCard(
                    "Sugar Intake", "${sugarIntake.toStringAsFixed(1)} g", Icons.cake, Colors.pink.shade100, ""),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHealthCard(
                    "Muscle Mass", "${muscleMass.toStringAsFixed(1)} kg", Icons.fitness_center, Colors.blue.shade100, ""),
              ],
            ),
            
            SizedBox(height: 20),
            
            
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(String title, String value, IconData icon, Color color, String suggestion) {
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
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (suggestion.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  suggestion,
                  style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
         
         
          ],
        ),
      ),
    );
  }



  Widget _buildReportCard(String title, String date) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.insert_drive_file, size: 40, color: Colors.blue),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}