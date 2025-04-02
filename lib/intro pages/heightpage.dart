import 'package:app/intro%20pages/weightpage.dart';
import 'package:flutter/material.dart';


class SelectHeightScreen extends StatefulWidget {
  @override
  _SelectHeightScreenState createState() => _SelectHeightScreenState();
}

class _SelectHeightScreenState extends State<SelectHeightScreen> {
  String selectedUnit = "cm";
  TextEditingController heightController = TextEditingController(text: "175");

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
          "Step 4 of 8",
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Select height",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            _buildUnitToggle(),
            SizedBox(height: 30),
            _buildHeightInput(),
            Spacer(),
            GestureDetector(
              onTap: heightController.text.isNotEmpty ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HeightWeightPickerPage()),
          );
        } : null,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: heightController.text.isNotEmpty ? Colors.black : Colors.grey,
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

  // Widget for unit toggle (Feet / Centimeter)
  Widget _buildUnitToggle() {
    return Container(
      width: 200,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ["Feet", "Centimetre"].map((unit) {
          bool isSelected = unit.toLowerCase() == selectedUnit.toLowerCase();
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedUnit = unit.toLowerCase();
                heightController.text = selectedUnit == "feet" ? "5'9" : "175";
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget for height input field
  Widget _buildHeightInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        SizedBox(width: 10),
        Text(
          selectedUnit == "feet" ? "ft" : "cm",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}