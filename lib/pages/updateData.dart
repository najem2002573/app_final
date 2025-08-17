import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';

class Updatedata extends StatefulWidget {
  const Updatedata({super.key});

  @override
  State<Updatedata> createState() => _UpdatedataState();
}

class _UpdatedataState extends State<Updatedata> {
  BackendManager manager = BackendManager();

  final ScrollController weightScrollController = ScrollController();
  final ScrollController heightScrollController = ScrollController();
  final ScrollController ageScrollController = ScrollController();


  final List<String> fitnessGoals = [
    "Lose Weight",
    "Keep Fit",
    "Lift for Strength & Gain Muscle Mass"
  ];

  String selectedGoal = "Lose Weight";

  final double itemWidth = 60.0;
  int selectedWeight = 70;
  int selectedHeight = 170;
  int selectedAge = 25;
  final int weightMin = 30;
  final int weightMax = 150;
  final int heightMin = 100;
  final int heightMax = 220;
  final int ageMin = 10;
  final int ageMax = 100;


@override
void initState() {
  super.initState();

  // Load saved values
  selectedWeight = manager.WEIGHT.toInt();
  selectedHeight = manager.HEIGHT.toInt();
  selectedAge = manager.age;

  // Add listeners
  weightScrollController.addListener(() {
    int selected = (weightMin + (weightScrollController.offset / itemWidth).round())
        .clamp(weightMin, weightMax);
    if (selected != selectedWeight) {
      setState(() => selectedWeight = selected);
    }
  });

  heightScrollController.addListener(() {
    int selected = (heightMin + (heightScrollController.offset / itemWidth).round())
        .clamp(heightMin, heightMax);
    if (selected != selectedHeight) {
      setState(() => selectedHeight = selected);
    }
  });

  ageScrollController.addListener(() {
    int selected = (ageMin + (ageScrollController.offset / itemWidth).round())
        .clamp(ageMin, ageMax);
    if (selected != selectedAge) {
      setState(() => selectedAge = selected);
    }
  });

  // Delay scroll jump until layout is ready
  WidgetsBinding.instance.addPostFrameCallback((_) {
    weightScrollController.jumpTo((selectedWeight - weightMin) * itemWidth);
    heightScrollController.jumpTo((selectedHeight - heightMin) * itemWidth);
    ageScrollController.jumpTo((selectedAge - ageMin) * itemWidth);
  });
}



  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.deepPurple),
        title: Text(
          "Update Health info",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Select Your Weight (kg):"),
            _buildHorizontalPicker(
              controller: weightScrollController,
              min: 30,
              max: 150,
              value: selectedWeight,
             
            ),
            SizedBox(height: 16),

            _buildLabel("Select Your Height (cm):"),
            _buildHorizontalPicker(
              controller: heightScrollController,
              min: 100,
              max: 220,
              value: selectedHeight,
              
            ),
            SizedBox(height: 16),

            _buildLabel("Select Your Age:"),
            _buildHorizontalPicker(
              controller: ageScrollController,
              min: 10,
              max: 100,
              value: selectedAge,
           
            ),
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
                items: fitnessGoals
                    .map<DropdownMenuItem<String>>((String goal) {
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
                  manager.getPrediction();
                  print(
                      "the last Saved Data - Weight: $selectedWeight, Height: $selectedHeight, Age: $selectedAge, Goal: $selectedGoal");

                  manager.setHeight(selectedHeight.toDouble());
                  manager.setWeight(selectedWeight.toDouble());
                  manager.setAge(selectedAge);
                  manager.setGoal(selectedGoal);
                  manager.createLocalUserData();
                  manager.uploadUserDataToFirebase();
                  _showSuccessUpdatSnackBar(
                      "Updated Data Successfully!.", Colors.green);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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

Widget _buildHorizontalPicker({
  required ScrollController controller,
  required int min,
  required int max,
  required int value,
}) {
  return SizedBox(
    height: 100,
    child: Stack(
      alignment: Alignment.center,
      children: [
        ListView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemCount: max - min + 1,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 2 - itemWidth / 2,
          ),
          itemBuilder: (context, index) {
            int val = min + index;
            bool isSelected = val == value;
            return Container(
              width: itemWidth,
              alignment: Alignment.center,
              child: Text(
                "$val",
                style: TextStyle(
                  fontSize: isSelected ? 24 : 16,
                  color: isSelected ? Colors.purple.shade200 : Colors.grey,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          bottom: 0,
          child: Container(
            width: 2,
            height: 50,
            color: Colors.grey.shade400,
          ),
        ),
      ],
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