import 'package:flutter/material.dart';

class Food extends StatelessWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalorieGoal(1800, 1200), // Example values: goal vs consumed
            SizedBox(height: 20),
            _buildFoodSuggestions(),
            SizedBox(height: 20),
            _buildWaterTracker(),
            SizedBox(height: 20),
            _buildNutritionBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieGoal(int goal, int consumed) {
    double progress = consumed / goal;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daily Calorie Goal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearProgressIndicator(value: progress, minHeight: 10, color: Colors.orange),
            SizedBox(height: 5),
            Text("$consumed / $goal kcal consumed", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodSuggestions() {
    List<Map<String, String>> foods = [
      {"name": "Grilled Chicken", "calories": "400 kcal", "image": "https://via.placeholder.com/150"},
      {"name": "Salmon & Veggies", "calories": "500 kcal", "image": "https://via.placeholder.com/150"},
      {"name": "Oatmeal & Fruits", "calories": "350 kcal", "image": "https://via.placeholder.com/150"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recommended Meals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: foods.map((food) {
            return Card(
              child: ListTile(
                leading: Image.network(food['image']!),
                title: Text(food['name']!),
                subtitle: Text(food['calories']!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWaterTracker() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Water Intake", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(8, (index) => Icon(Icons.local_drink, color: index < 5 ? Colors.blue : Colors.grey)),
            ),
            SizedBox(height: 5),
            Text("5 / 8 glasses consumed", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionBreakdown() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Macronutrient Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Carbs: 50%  •  Protein: 30%  •  Fats: 20%", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
