  import 'package:app/services/manager.dart';
  import 'package:app/services/nutrients.dart';
  import 'package:flutter/material.dart';
  import 'package:fl_chart/fl_chart.dart';
  //import 'package:firebase_storage/firebase_storage.dart'; // For uploading images to Firebase Storage
 // For storing and retrieving data from Firestore
  import 'package:hive_flutter/hive_flutter.dart';






  class DailyDietPage extends StatefulWidget {
    @override
    State<DailyDietPage> createState() => _DailyDietPageState();
  }



  //this object calls the manager class to contact backend and api services
  final manager=BackendManager();

  //this object has the nutrients of food we captured, we get it from the manager class after detecting 
  // and calculating via api's





  class _DailyDietPageState extends State<DailyDietPage> {


      //dealing with water cups logic
      int consumed =0;
      final double glassMl = 0.25;
      final double totalMl = 1.5;



      //updating the water glasses when user clicks
      void _handleCupTap(int index) {
          setState(() {
            if (consumed == index + 1) {
              consumed--;
            } else {
              consumed = index + 1;
            }
          print("consume is : $consumed");
        
          todayNutrients.waterGlasses = consumed;
          print("the hive value of consumed is : ${todayNutrients.waterGlasses}");
          setTodayNutrients(todayNutrients);
          Hive.box<Nutrients>('nutrientsBox').put('today', todayNutrients);
          //todayNutrients.save(); // Save the update to Hive
          });

              // Optionally save to Hive:
              // Hive.box('todayNutrients').put('waterGlasses', consumed);
       }
   

      int loadWaterConsume(){
        final box=Hive.box<Nutrients>('nutrientsBox');
        setState(() {
          this.consumed=box.get('today')?.waterGlasses ?? 0;
          print("after loading the state of consumed water is set to $consumed");
        });
        return consumed;
      }


    //the nutrients are saved here
  Nutrients todayNutrients = Nutrients();



//load nutrients so we wont loose the data if app is closed
@override
void initState() {
  super.initState();
  
  // Load nutrients from Hive asynchronously
  loadNutrients();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    loadWaterConsume();
  });
  this.consumed = todayNutrients?.waterGlasses ?? 0;
 // print("in the init state the loaded value of consumed is $consumed");
  
}

void loadNutrients() async {
  await manager.loadTodayNutrients();  // Load data from Hive
  setState(() {
    todayNutrients = manager.getNutrientValues();  // Update the UI with loaded data
  });
}




  //to update the nutrients each time we capture food photo, the call is from manager class from open ai api
  //getnutrients() function



  ///////////////////////////////////////////////////////////////////////////////////////////////////////

  void saveTodayToHive() async {
  final box = Hive.box<Nutrients>('nutrientsBox');
  await box.put('today', todayNutrients);
}




/// to set the nutrient . especially when starting the app 
void setTodayNutrients(Nutrients todays){
  setState(() {
  manager.todayNutrints=todays;
  manager.uploadTodayNutrientsFirebase();
  
  this.todayNutrients=todays;  
  });
  
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

    final List<String> dietTips = [
      "Drink water before meals.",
      "Add more fiber to your diet.",
      "Avoid late-night snacking.",
      "Eat more whole foods.",
      "Include healthy fats in meals."
    ];

    @override
    Widget build(BuildContext context) {
      manager.loadTodayNutrients();
      setState(() {
        todayNutrients=manager.getNutrientValues();
      });
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
        
      );
    }

    Widget buildNutritionCard() {
      manager.loadTodayNutrients();
      setState(() {
        todayNutrients=manager.getNutrientValues();
      });
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
                  todayNutrients.getCals().toStringAsFixed(1),
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
              tween: Tween<double>(begin: 0, end: todayNutrients.getCals() / 2500),
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
                _buildAnimatedMacroTile("Sugars", todayNutrients.getSugars().toStringAsFixed(1), Colors.cyan,
                    Icons.local_fire_department,todayNutrients.getSugars()/50),
                _buildAnimatedMacroTile(
                    "Protein", todayNutrients.getproteins().toString(), Colors.red, Icons.egg,todayNutrients.protein/50),
                _buildAnimatedMacroTile("Carbs", todayNutrients.getCarbs().toString(), Colors.amber,
                    Icons.breakfast_dining_outlined,todayNutrients.getCarbs()/50),
                _buildAnimatedMacroTile(
                    "Fat", todayNutrients.getFats().toString(), Colors.purple.shade400, Icons.icecream,todayNutrients.getFats()/50),
              ],
            ),
            SizedBox(height: 20),
            AnimatedContainer(
              width: 500,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: ElevatedButton.icon(
                onPressed: () async {
                      // Step 1: Pick image and get label
                      String foodName = await manager.pickAndUploadImage();
                      print("Picked food label: $foodName");


                      // Step 2: Fetch nutrients from backend
                      await manager.getNutrients(foodName);
                      print("Fetched nutrients from backend");
                      

                      todayNutrients = manager.getNutrientValues();
                      await manager.uploadTodayNutrientsFirebase();
                      // Step 3: Update UI with new nutrients
                      setState((){
                        todayNutrients = todayNutrients;
                        
                        
                      });
                    foodName="";
                    saveTodayToHive();
                    
                    },
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
      String title, String value, Color color, IconData icon,double val) {
    return SingleChildScrollView(
      child: TweenAnimationBuilder<double>(
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
                        value: val,
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
      ),
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

    print("in the build of water row the initial consumed value is : $consumed");
    double currentMl = glassMl * consumed;

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
              Text(" / ${totalMl.toDouble()}ML",
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
  bool filled = index < this.consumed;
  return GestureDetector(
    onTap: () => _handleCupTap(index),
    child: AnimatedContainer(
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
    double sumNutrients=(todayNutrients.getCarbs()+todayNutrients.getFats()+todayNutrients.getproteins());
    if (sumNutrients==0) sumNutrients=1; 
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
                            value: todayNutrients.getCarbs()/sumNutrients,
                            title: 'Carbs',
                            color: Colors.amber,
                            radius: 55,
                            titleStyle: TextStyle(fontWeight: FontWeight.bold)),
                        PieChartSectionData(
                            value: todayNutrients.getproteins()/sumNutrients,
                            title: 'Protein',
                            color: Colors.redAccent,
                            radius: 55,
                            titleStyle: TextStyle(fontWeight: FontWeight.bold)),
                        PieChartSectionData(
                            value: todayNutrients.getFats()/sumNutrients,
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