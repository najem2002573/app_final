import 'package:app/intro%20pages/heightpage.dart';
import 'package:app/pages/home.dart';
import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';

class ChooseGoalScreen extends StatefulWidget {
  @override
  _ChooseGoalScreenState createState() => _ChooseGoalScreenState();
}

class _ChooseGoalScreenState extends State<ChooseGoalScreen> {
  String? selectedGoal;
  final manager=BackendManager();
  final List<Map<String, dynamic>> goalOptions = [
    {'label': 'Lose weight', 'emoji': '🏋️'},
    {'label': 'Keep fit', 'emoji': '🍀'},
    {'label': 'Get stronger', 'emoji': '💪'},
    {'label': 'Gain muscle mass', 'emoji': '🏋️‍♂️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        
        
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                "Choose main goal",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            SizedBox(height: 30),
            Column(
              children: goalOptions.map((option) {
                bool isSelected = selectedGoal == option['label'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGoal = option['label'];
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Text(
                          option['emoji'],
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(width: 15),
                        Text(
                          option['label'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        if (isSelected)
                          Icon(Icons.check_circle,
                              color: Colors.teal, size: 22),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            GestureDetector(
              onTap: selectedGoal != null
                  ? () {
                    
                    print("the user goal is : $selectedGoal");
                    manager.setGoal(selectedGoal.toString());
                    
                    manager.createLocalUserData();
                    manager.uploadUserDataToFirebase();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()),
                      );
                    }
                  : null,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color:
                      selectedGoal != null ? Colors.teal.shade400 : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Lets start the journey!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}