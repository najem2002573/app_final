import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Calories extends StatelessWidget {
  Calories({super.key});
  final manager=BackendManager();
  final List<double> activityStats = [7.5, 9.8, 1.2]; // Distance, Steps, Points
  final List<String> activityLabels = ["Distance", "Steps", "Points"];
  final List<String> activityUnits = ["m", "", ""];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCalorieSummary(),
              _buildDatePicker(),
              _buildTotalCalories(),
              _buildActivityStats(),
              _buildActivityBreakdown(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieSummary() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Today, 8 Jul",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "1 883 Kcal",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Track your activity",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 10,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assets/fitness_girl.png"), // Replace with actual image
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 5; i <= 11; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: i == 8 ? Colors.black : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$i",
                style: TextStyle(
                  color: i == 8 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalCalories() {
    return Column(
      children: const [
        Text(
          "1 883 Kcal",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          "Total Kilocalories",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildActivityStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 150,
        child: BarChart(
          BarChartData(
            barGroups: List.generate(
              activityStats.length,
              (index) => _buildBar(activityStats[index]),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(activityLabels[value.toInt()], style: TextStyle(fontSize: 12));
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBar(double value) {
    return BarChartGroupData(
      x: activityStats.indexOf(value),
      barRods: [
        BarChartRodData(
          toY: value,
          color: Colors.black,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildActivityBreakdown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActivityCard("628 Kcal", "Dumbbell", Icons.fitness_center, Colors.pinkAccent),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildActivityCard("235 Kcal", "Treadmill", Icons.directions_walk, Colors.grey.shade300),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActivityCard("432 Kcal", "Rope", Icons.sports_kabaddi, Colors.grey.shade300),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String kcal, String name, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(kcal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(name, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}