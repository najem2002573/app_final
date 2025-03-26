import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyDietPage extends StatelessWidget {
  final List<String> dietTips = [
    "Drink water before meals.",
    "Add more fiber to your diet.",
    "Avoid late-night snacking.",
    "Eat more whole foods.",
    "Include healthy fats in meals."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text("Food"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNutritionCard(),
            SizedBox(height: 20),
            _buildWaterIntakeCard(),
            SizedBox(height: 20),
            buildMealTimeSuggestions(),
            SizedBox(height: 20),
            buildMealBreakdown(),
            SizedBox(height: 20),
            buildNutrientBreakdownChart(),
            SizedBox(height: 20),
            _buildDietTips(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_dining), label: "Diet"),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nutrition Intake", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text("Consumed today", style: TextStyle(color: Colors.grey)),
          Row(
            children: [
              Text("530", style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(" / 2,500 Cal", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
          SizedBox(height: 6),
          LinearProgressIndicator(
            value: 530 / 2500,
            backgroundColor: Colors.grey.shade200,
            color: Colors.teal,
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildNutritionTile("Calories", "856Cal", Colors.cyan),
              _buildNutritionTile("Protein", "128Cal", Colors.red),
              _buildNutritionTile("Carbs", "173Cal", Colors.amber),
              _buildNutritionTile("Fat", "199Cal", const Color.fromARGB(255, 181, 52, 204)),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("+ Add Meals",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNutritionTile(String title, String value, Color color) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircularProgressIndicator(
            value: 0.6,
            strokeWidth: 5,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(color: Colors.grey.shade600))
        ],
      ),
    );
  }

  Widget _buildWaterIntakeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Water Intake", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("3 of 6 glasses consumed", style: TextStyle(color: Colors.grey.shade600)),
          SizedBox(height: 8),
          Row(
            children: [
              Text("2.6", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              Text("ML", style: TextStyle(color: Colors.grey.shade600)),
              Text(" / 5ML", style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return Icon(
                index < 3 ? Icons.local_drink : Icons.local_drink_outlined,
                color: Colors.cyan,
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildMealTile(String title, List<String> items) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          ...items.map((e) => Text("• $e", style: TextStyle(color: Colors.grey[700]))),
        ],
      ),
    );
  }


  Widget _buildDietTips() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Daily Diet Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...dietTips.map((tip) => Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("• $tip", style: TextStyle(color: Colors.grey.shade700)),
          )),
        ],
      ),
    );
  }
}


final List<String> dietTips = [
  "Drink plenty of water",
  "Include fiber-rich foods",
  "Avoid processed sugar",
  "Eat balanced meals",
];


  Widget buildMealTimeSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🍽️ Meal Time Suggestions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        _styledSuggestion("Breakfast", "8:00 AM"),
        _styledSuggestion("Lunch", "1:00 PM"),
        _styledSuggestion("Snack", "4:00 PM"),
        _styledSuggestion("Dinner", "7:00 PM"),
      ],
    );
  }

Widget buildMealBreakdown() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("🍱 Meal Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 12),
      SizedBox(
        height: 150, // Set a height to prevent layout issues
        child: SingleChildScrollView(
          
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            children: [
              _buildMealTile("Breakfast", ["🥣 Oats", "🍌 Banana", "🥛 Almond Milk"]),
              _buildMealTile("Lunch", ["🍗 Grilled Chicken", "🍚 Rice", "🥗 Salad"]),
              _buildMealTile("Dinner", ["🐟 Salmon", "🍠 Quinoa", "🥦 Vegetables"]),
              _buildMealTile("Snacks", ["🍦 Yogurt", "🥜 Nuts"]),
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _buildMealTile(String title, List<String> items) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 6),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 2.0),
                child: Text(e, style: TextStyle(color: Colors.grey[800])),
              )),
        ],
      ),
    );
  }

  Widget buildNutrientBreakdownChart() {
    return Container(
      height: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text("🥗 Macronutrient Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 40, color: Colors.amber, title: 'Carbs', radius: 40),
                  PieChartSectionData(value: 30, color: Colors.red, title: 'Protein', radius: 40),
                  PieChartSectionData(value: 30, color: const Color.fromARGB(255, 181, 52, 204), title: 'Fat', radius: 40),
                ],
                sectionsSpace: 4,
                centerSpaceRadius: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDietTips() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("💡 Daily Diet Tips", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...dietTips.map((tip) => Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(child: Text(tip, style: TextStyle(color: Colors.grey.shade700))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _styledSuggestion(String meal, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 18, color: Colors.deepPurple),
          SizedBox(width: 8),
          Text("$meal: ", style: TextStyle(fontWeight: FontWeight.w600)),
          Text(time, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
