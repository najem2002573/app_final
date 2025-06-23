import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';

class Updatedata extends StatefulWidget {
  const Updatedata({super.key});

  @override
  State<Updatedata> createState() => _UpdatedataState();
}

class _UpdatedataState extends State<Updatedata> {
  BackendManager manager = BackendManager();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final List<String> fitnessGoals = [
    "Lose Weight",
    "Keep Fit",
    "Lift for Strength & Gain Muscle Mass"
  ];

  String selectedGoal = "Lose Weight";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.deepPurple),
          title: Text("Update Health info", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
      
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Enter Your Weight (kg):"),
            _buildStyledInput(weightController, "Enter weight"),
            SizedBox(height: 16),

            _buildLabel("Enter Your Height (cm):"),
            _buildStyledInput(heightController, "Enter height"),
            SizedBox(height: 16),

            _buildLabel("Enter Your Age:"),
            _buildStyledInput(ageController, "Enter age"),
            SizedBox(height: 16),

            _buildLabel("Select Your Fitness Goal:"),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 1.2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: DropdownButton<String>(
                value: selectedGoal,
                isExpanded: true,
                underline: SizedBox(),
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
            ),
            SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  String weight = weightController.text;
                  String height = heightController.text;
                  String age = ageController.text;

                  manager.getPrediction();
                  print("Saved Data - Weight: $weight, Height: $height, Age: $age, Goal: $selectedGoal");

                  if (weight.isNotEmpty && height.isNotEmpty && age.isNotEmpty) {
                    manager.setHeight(double.parse(height));
                    manager.setWeight(double.parse(weight));
                    manager.setAge(int.parse(age));
                    manager.setGoal(selectedGoal);
                    manager.createLocalUserData();
                    manager.uploadUserDataToFirebase();
                    _showSuccessUpdatSnackBar("Updated Data Successfully!.", Colors.green);
                    Navigator.pop(context);
                  } else {
                    _showSuccessUpdatSnackBar("Failed to update", Colors.red);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildStyledInput(TextEditingController controller, String hintText) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _showSuccessUpdatSnackBar(String title, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }
}