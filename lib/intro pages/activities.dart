import 'package:app/intro%20pages/goalscreen.dart';
import 'package:app/pages/home.dart';
import 'package:app/services/manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChooseActivitiesScreen extends StatefulWidget {
  @override
  _ChooseActivitiesScreenState createState() => _ChooseActivitiesScreenState();
}

class _ChooseActivitiesScreenState extends State<ChooseActivitiesScreen> {
  List<String> selectedActivities = [];
  final manager=BackendManager();
  final List<Map<String, dynamic>> activities = [
    {'label': 'Stretch', 'emoji': '🤸', 'color': Colors.blue.shade100},
    {'label': 'Cardio', 'emoji': '🏃', 'color': Colors.pink.shade100},
    {'label': 'Yoga', 'emoji': '🧘', 'color': Colors.yellow.shade100},
    {'label': 'Power training', 'emoji': '🏋️', 'color': Colors.green.shade100},
    {'label': 'Dancing', 'emoji': '💃', 'color': Colors.red.shade100},
    {'label': 'Football', 'emoji': '⚽', 'color': Colors.orange.shade100},
    {'label': 'Basketball', 'emoji': '🏀', 'color': Colors.purple.shade100},
    {'label': 'Swimming', 'emoji': '🏊', 'color': Colors.teal.shade100},
    {'label': 'Cycling', 'emoji': '🚴', 'color': Colors.indigo.shade100},
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChooseGoalScreen()));
                 
            },
            child: Text(
              "Skip",
              style: TextStyle(color: Colors.teal, fontSize: 16),
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
                "Choose activities that interest",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: activities.map((activity) {
                  bool isSelected =
                      selectedActivities.contains(activity['label']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedActivities.remove(activity['label']);
                        } else {
                          selectedActivities.add(activity['label']);
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : activity['color'],
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
                            activity['emoji'],
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              activity['label'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle,
                                color: Colors.teal, size: 22),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            GestureDetector(
              onTap: selectedActivities.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChooseGoalScreen()),
                      );
                    }
                  : null,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: selectedActivities.isNotEmpty
                      ? Colors.teal.shade400
                      : Colors.grey,
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