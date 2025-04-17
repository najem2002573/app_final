import 'package:app/intro%20pages/activities.dart';
import 'package:app/intro%20pages/currentlevel.dart';
import 'package:app/pages/food.dart';
import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';

class HeightWeightPickerPage extends StatefulWidget {
  @override
  _HeightWeightPickerPageState createState() => _HeightWeightPickerPageState();
}

class _HeightWeightPickerPageState extends State<HeightWeightPickerPage> {
  int height = 170;
  int weight = 66;
  final manager=BackendManager();
  final double itemWidth = 80;
  final ScrollController _heightController = ScrollController();
  final ScrollController _weightController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heightController.addListener(() {
      int selected =
          (heightMin + (_heightController.offset / itemWidth).round())
              .clamp(heightMin, heightMax);
      if (selected != height) {
        setState(() {
          height = selected;
        });
      }
    });
    _weightController.addListener(() {
      int selected =
          (weightMin + (_weightController.offset / itemWidth).round())
              .clamp(weightMin, weightMax);
      if (selected != weight) {
        setState(() {
          weight = selected;
        });
      }
    });
  }

  final int heightMin = 140;
  final int heightMax = 220;
  final int weightMin = 40;
  final int weightMax = 160;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
              Navigator.of(context).pop();
                  
          }),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text("Set Your Height",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
            const SizedBox(height: 25),
            Text("$height cm",
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
            const SizedBox(height: 8),
            _buildHorizontalPicker(
              controller: _heightController,
              min: heightMin,
              max: heightMax,
              value: height,
            ),
            const SizedBox(height: 100),
            const Text("Set Your Weight",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 25),
            Text("$weight kg",
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
            const SizedBox(height: 8),
            _buildHorizontalPicker(
              controller: _weightController,
              min: weightMin,
              max: weightMax,
              value: weight,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print("the height is $height and the weight is $weight");
                    print("the height is ${height.toDouble()} and weight is ${weight.toDouble()}");
                    manager.setHeight(height.toDouble());
                    manager.setWeight(weight.toDouble());
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChooseTrainingLevelScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Continue",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
}