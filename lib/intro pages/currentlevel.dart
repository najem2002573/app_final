import 'package:app/intro%20pages/activities.dart';
import 'package:flutter/material.dart';


class ChooseTrainingLevelScreen extends StatefulWidget {
  @override
  _ChooseTrainingLevelScreenState createState() => _ChooseTrainingLevelScreenState();
}

class _ChooseTrainingLevelScreenState extends State<ChooseTrainingLevelScreen> {
  String? selectedLevel;

  final List<Map<String, String>> trainingLevels = [
    {'title': 'Beginner', 'subtitle': 'I want to start training'},
    {'title': 'Irregular training', 'subtitle': 'I train 1-2 times a week'},
    {'title': 'Medium', 'subtitle': 'I train 3-5 times a week'},
    {'title': 'Advanced', 'subtitle': 'I train more than 5 times a week'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "Step 7 of 8",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Skip",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          )
        ],
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
                "Choose training level",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30),
            Column(
              children: trainingLevels.map((level) {
                bool isSelected = selectedLevel == level['title'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLevel = level['title'];
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level['title']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          level['subtitle']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            GestureDetector(
              onTap: selectedLevel != null ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChooseActivitiesScreen()),
          );
        } : null,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: selectedLevel != null ? Colors.black : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Continue",
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