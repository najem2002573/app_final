import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String selectedGender = "Male";
  DateTime selectedDate = DateTime.now();

  final String maleImageUrl =
      "https://www.shareicon.net/data/512x512/2015/09/18/103160_man_512x512.png";
  final String femaleImageUrl =
      "https://static.vecteezy.com/system/resources/previews/004/899/680/non_2x/beautiful-blonde-woman-with-makeup-avatar-for-a-beauty-salon-illustration-in-the-cartoon-style-vector.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "Please improve your personal informat...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderOption(
                      "Male", maleImageUrl, selectedGender == "Male"),
                  SizedBox(width: 24),
                  _buildGenderOption(
                      "Female", femaleImageUrl, selectedGender == "Female"),
                ],
              ),
              SizedBox(height: 40),
              Text(
                "Select Date of Birth",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate,
                  maximumDate: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Next button logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, String imageUrl, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor:
                isSelected ? Colors.purple.shade100 : Colors.grey.shade200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Image.network(
                    imageUrl,
                    height: 65,
                    width: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.check_circle,
                        color: Colors.teal.shade400, size: 20),
                  )
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            gender,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.black
                  : const Color.fromARGB(255, 158, 158, 158),
            ),
          ),
        ],
      ),
    );
  }
}