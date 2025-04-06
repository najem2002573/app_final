import 'package:app/pages/manager.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // For handling image files
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


import 'package:flutter/material.dart'; // Core Flutter UI components
import 'package:image_picker/image_picker.dart'; // For image selection
//import 'package:firebase_storage/firebase_storage.dart'; // For uploading images to Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // For storing and retrieving data from Firestore


class DailyDietPage extends StatefulWidget {
  @override
  State<DailyDietPage> createState() => _DailyDietPageState();
}



BackendManager manager=BackendManager();

class _DailyDietPageState extends State<DailyDietPage> {

File? _selectedImage; // Stores the selected image file
final ImagePicker _picker = ImagePicker(); // Image picker instance
TextEditingController foodController = TextEditingController(); // Controller for food input
TextEditingController caloriesController = TextEditingController(); // Controller for calories input

final TextEditingController _foodController = TextEditingController();
final TextEditingController _caloriesController = TextEditingController();

 
// pick an image + upload it
Future<void> pickAndUploadImage() async {
  try {
    // Step 1: Pick an image from the camera
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      // No image selected, return early
      return;
    }

    // Step 2: Upload the image to Firebase Storage
    String imageUrl = await uploadImageToFirebase(image);

    // Step 3: Process the image to get nutritional data (e.g., carbs, proteins, etc.)
    Map<String, dynamic> nutritionalData = await extractNutritionalData(image);

    // Step 4: Save the image URL and nutritional data to Firestore
    await saveImageDataToFirestore(imageUrl, nutritionalData);

    // Optionally, show a success message to the user
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded and processed successfully!')));
  } catch (e) {
    // Handle errors
    print('Error uploading image: $e');
  }
}


//analyze and get nutrients data
Future<Map<String, dynamic>> extractNutritionalData(XFile image) async {
  try {
    // Example: Send image to an external API for food recognition
    // For example, use Edamam API (you need an API key and proper endpoint setup)

    var request = http.MultipartRequest('POST', Uri.parse('https://api.edamam.com/food-database/v2/nutrients'));
    request.fields['app_id'] = 'your_app_id'; // API ID
    request.fields['app_key'] = 'your_app_key'; // API Key

    // Attach the image file
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // Parse the response and extract nutritional data (carbs, proteins, etc.)
      Map<String, dynamic> nutritionInfo = jsonDecode(responseData);
      print(nutritionInfo);
      print("***********************==========================************************==========");
      return nutritionInfo;
    } else {
      throw Exception('Failed to fetch nutritional data');
    }
  } catch (e) {
    print('Error extracting nutritional data: $e');
    
      print("***********************==========================************************==========");
    rethrow;
  }
}



//upload it to firestore

Future<String> uploadImageToFirebase(XFile image) async {
  try {
    // Get a reference to Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;

    // Create a reference for the image file
    Reference ref = storage.ref().child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file to Firebase Storage
    await ref.putFile(File(image.path));

    // Get the download URL of the uploaded image
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading image to Firebase: $e');
    rethrow;
  }
}


//save

Future<void> saveImageDataToFirestore(String imageUrl, Map<String, dynamic> nutritionalData) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('photos').add({
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'nutritionalData': nutritionalData, // Save the nutritional data as a map
    });
  } catch (e) {
    print('Error saving data to Firestore: $e');
  }
}













  final List<String> dietTips = [
    "Drink water before meals.",
    "Add more fiber to your diet.",
    "Avoid late-night snacking.",
    "Eat more whole foods.",
    "Include healthy fats in meals."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min, // Centers the content nicely
          children: [
            Text(
              "Food",
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.restaurant, color: Colors.white),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNutritionCard(),
            SizedBox(height: 20),
            _buildWaterIntakeCard(),
            SizedBox(height: 20),
            buildMealTimeSuggestions(),
            SizedBox(height: 20),
            buildMealBreakdown(),
            SizedBox(height: 20),
            buildNutrientBreakdownChart(),
            SizedBox(height: 20),
            buildDietTips(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_dining), label: "Diet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget buildNutritionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.purple.shade400),
              SizedBox(width: 8),
              Text(
                "Nutrition Intake",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text("Consumed today", style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                "530",
                style: TextStyle(
                  color: Colors.purple.shade400,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                " / 2,500 Cal",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 530 / 2500),
            duration: Duration(seconds: 1),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey.shade200,
              color: Colors.purple.shade400,
            ),
          ),
          SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildAnimatedMacroTile("Calories", "856Cal", Colors.cyan,
                  Icons.local_fire_department),
              _buildAnimatedMacroTile(
                  "Protein", "128Cal", Colors.red, Icons.egg),
              _buildAnimatedMacroTile("Carbs", "173Cal", Colors.amber,
                  Icons.breakfast_dining_outlined),
              _buildAnimatedMacroTile(
                  "Fat", "199Cal", Colors.purple.shade400, Icons.icecream),
            ],
          ),
          SizedBox(height: 20),
          AnimatedContainer(
            width: 500,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: ElevatedButton.icon(
              onPressed: manager.pickAndUploadImage,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                "Add Meals",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMacroTile(
      String title, String value, Color color, IconData icon) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 0.6),
      duration: Duration(milliseconds: 1000),
      builder: (context, progress, child) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: color.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  Icon(icon, color: color, size: 20),
                ],
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(title, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroTile(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 0.6,
                strokeWidth: 5,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Icon(icon, size: 20, color: color),
            ],
          ),
          SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildWaterIntakeCard() {
    int consumed = 3;
    double currentMl = 2.6;
    double totalMl = 5.0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.shade100,
            blurRadius: 10,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_outlined, color: Colors.cyan),
              SizedBox(width: 6),
              Text(
                "Water Intake",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "$consumed of 6 glasses consumed",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: currentMl),
                duration: Duration(milliseconds: 1000),
                builder: (context, value, _) => Text(
                  "${value.toStringAsFixed(1)}",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(" ML", style: TextStyle(color: Colors.grey.shade600)),
              Text(" / ${totalMl.toInt()}ML",
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              bool filled = index < consumed;
              return AnimatedContainer(
                duration: Duration(milliseconds: 500 + index * 100),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: filled ? Colors.cyan : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: filled
                      ? [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  filled ? Icons.local_drink : Icons.local_drink_outlined,
                  color: filled ? Colors.white : Colors.cyan,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildMealTimeSuggestions() {
    final mealTimes = [
      {"meal": "Breakfast", "time": "8:00 AM", "icon": Icons.free_breakfast},
      {"meal": "Lunch", "time": "1:00 PM", "icon": Icons.lunch_dining},
      {"meal": "Snack", "time": "4:00 PM", "icon": Icons.emoji_food_beverage},
      {"meal": "Dinner", "time": "7:00 PM", "icon": Icons.dinner_dining},
    ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.deepPurple),
              SizedBox(width: 6),
              Text("Meal Time Suggestions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 14),
          ...mealTimes.asMap().entries.map((entry) {
            int index = entry.key;
            var meal = entry.value;

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 500 + index * 200),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(meal['icon'] as IconData,
                        color: Colors.deepPurple, size: 20),
                    SizedBox(width: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "${meal['meal']}: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          TextSpan(
                              text: "${meal['time'] as String} ",
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildMealBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("\u{1F371} Meal Breakdown",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMealTile("Breakfast", [
                  "\u{1F963} Oats",
                  "\u{1F34C} Banana",
                  "\u{1F95B} Almond Milk"
                ]),
                _buildMealTile("Lunch", [
                  "\u{1F357} Grilled Chicken",
                  "\u{1F35A} Rice",
                  "\u{1F957} Salad"
                ]),
                _buildMealTile("Dinner", [
                  "\u{1F41F} Salmon",
                  "\u{1F360} Quinoa",
                  "\u{1F966} Vegetables"
                ]),
                _buildMealTile(
                    "Snacks", ["\u{1F366} Yogurt", "\u{1F95C} Nuts"]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealTile(String title, List<String> items) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 6),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 2.0),
                child: Text(e, style: TextStyle(color: Colors.grey[800])),
              )),
        ],
      ),
    );
  }

  Widget buildNutrientBreakdownChart() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 12, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("🥗 Macronutrient Breakdown",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(Icons.auto_graph_rounded, color: Colors.teal),
            ],
          ),
          SizedBox(height: 16),

          // FIX: Wrap Expanded with SizedBox and give it height
          SizedBox(
            height: 200,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                            value: 40,
                            title: 'Carbs',
                            color: Colors.amber,
                            radius: 55,
                            titleStyle: TextStyle(fontWeight: FontWeight.bold)),
                        PieChartSectionData(
                            value: 30,
                            title: 'Protein',
                            color: Colors.redAccent,
                            radius: 55,
                            titleStyle: TextStyle(fontWeight: FontWeight.bold)),
                        PieChartSectionData(
                            value: 30,
                            title: 'Fat',
                            color: Colors.purpleAccent,
                            radius: 55,
                            titleStyle: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDietTips() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("\u{1F4A1} Daily Diet Tips",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...dietTips.map((tip) => Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text(tip,
                            style: TextStyle(color: Colors.grey.shade700))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _styledSuggestion(String meal, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 18, color: Colors.deepPurple),
          SizedBox(width: 8),
          Text("$meal: ", style: TextStyle(fontWeight: FontWeight.w600)),
          Text(time, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}


