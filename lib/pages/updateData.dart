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