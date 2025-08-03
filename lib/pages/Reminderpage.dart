import 'package:app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';


class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}



class _ReminderPageState extends State<ReminderPage> {
  TimeOfDay selectedTime = TimeOfDay(hour: 20, minute: 0);
  String selectedRepeat = "Everyday";
  late Box remindersBox;

  final List<String> repeatOptions = [
    "Everyday", "Mon - Fri", "Weekends", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
  ];

  @override
  void initState() {
    super.initState();
    _initStorage();
   
  }

  /// Initialize Hive for local storage
 Future<void> _initStorage() async {
  remindersBox = await Hive.openBox('remindersBox');
  setState(() {
    selectedTime = TimeOfDay(
      hour: remindersBox.get('hour', defaultValue: 20),
      minute: remindersBox.get('minute', defaultValue: 0),
    );
    selectedRepeat = remindersBox.get('repeat', defaultValue: "Everyday");
  });
}






  /// Schedule a reminder using WorkManager
  void _scheduleReminder() {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year, now.month, now.day, selectedTime.hour, selectedTime.minute,
    );

    if (scheduledTime.isBefore(now)) {
  // Move to the next day if time has already passed
  scheduledTime = scheduledTime.add(Duration(days: 1));
}




   void scheduleReminder() {
  final now = DateTime.now();
  final scheduledTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);


   }}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.deepPurple),
        title: Text("Reminder", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text("Please select reminder time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),
                  
                  // Time Picker
                  SizedBox(
                    height: 260,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime(2024, 1, 1, selectedTime.hour, selectedTime.minute),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() {
                            selectedTime = TimeOfDay.fromDateTime(newTime);
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  Text("How often repeat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 18),
                  
                  Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    children: repeatOptions.map((option) {
                      final isSelected = selectedRepeat == option;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRepeat = option;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                    onPressed: () async {
                          if (remindersBox.isOpen) {
                            remindersBox.put('hour', selectedTime.hour);
                            remindersBox.put('minute', selectedTime.minute);
                            remindersBox.put('repeat', selectedRepeat);

                            _scheduleReminder();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Reminder saved")),
                            );
                          } else {
                            // Show an error if the box isn't initialized
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Storage is not ready. Please try again.")),
                            );
                          }
                        },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                ),
                child: Text("Save", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}