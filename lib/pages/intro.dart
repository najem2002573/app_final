import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BodyMetricsChart extends StatelessWidget {
  final manager=BackendManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Health Metrics Chart"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Muscle Mass vs Body Fat vs Weight vs BMI",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 20),
            _buildBarChart(),
            SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // *Bar Chart Widget*
  Widget _buildBarChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 80, // Adjust based on highest value
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  List<String> labels = ["Muscle Mass", "Body Fat", "Weight", "BMI"];
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(labels[value.toInt()], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: _generateBarGroups(),
        ),
      ),
    );
  }

  // *Generate Bar Groups*
  List<BarChartGroupData> _generateBarGroups() {
    List<double> values = [54.4, 24.5, 68, 22.5];
    List<Color> colors = [Colors.blue, Colors.red, Colors.green, Colors.purple];

    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: colors[index],
            width: 20,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(show: true, toY: 80, color: Colors.grey[300]!),
          ),
        ],
      );
    });
  }

  // *Legend Widget*
  Widget _buildLegend() {
    List<Map<String, dynamic>> legends = [
      {"color": Colors.blue, "label": "Muscle Mass"},
      {"color": Colors.red, "label": "Body Fat"},
      {"color": Colors.green, "label": "Weight"},
      {"color": Colors.purple, "label": "BMI"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: legends.map((legend) {
        return Row(
          children: [
            Container(width: 12, height: 12, color: legend["color"]),
            SizedBox(width: 6),
            Text(legend["label"], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        );
      }).toList(),
    );
  }
}