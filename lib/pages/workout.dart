import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class FitnessDashboardScreen extends StatefulWidget {
  @override
  _FitnessDashboardScreenState createState() => _FitnessDashboardScreenState();
}

class _FitnessDashboardScreenState extends State<FitnessDashboardScreen> {
  int _selectedIndex = 0;
  String selectedCategory = "Lift for\nStrength";
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Map<String, dynamic>> workoutList = [
    {
      "title": "Chest Strength Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "953 kcal",
      "image":
          "https://cdn.muscleandstrength.com/sites/default/files/field/feature-image/workout/10mass_feature.jpg"
    },
    {
      "title": "Power Leg Fire Sessions",
      "duration": "1 Hour, 25 Minutes",
      "calories": "351 kcal",
      "image":
          "https://shop.bodybuilding.com/cdn/shop/articles/leg-workouts-for-men-get-thicker-quads-glutes-and-hams-986493.jpg?v=1737673309&width=900"
    },
    {
      "title": "Back Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://cdn.shopify.com/s/files/1/0816/2082/8435/files/Back_Cover_1024x1024.jpg?v=1707160835"
    },
    {
      "title": "Biceps Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://shop.bodybuilding.com/cdn/shop/articles/arm-workouts-for-men-to-build-bigger-biceps-822489.jpg?v=1731882647&width=900"
    },
    {
      "title": "Triceps Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://www.kettlebellkings.com/cdn/shop/articles/9ef303d8aa70a7750d93df68c947b645_6ad0537f-1b04-42d1-8131-a630f2cd5dc6.jpg?v=1739267183&width=900"
    },
    {
      "title": "Shoulder Training",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2023/05/shutterstock_336330470-scaled.jpg?resize=2048%2C1365&ssl=1"
    },
    {
      "title": "Full Body Power Workout",
      "duration": "1 Hour, 25 Minutes",
      "calories": "673 kcal",
      "image":
          "https://i0.wp.com/www.muscleandfitness.com/wp-content/uploads/2019/04/triceps-pushup-lean-muscular.jpg?w=940&h=529&crop=1&quality=86&strip=all"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            _buildWelcomeMessage(),
            SizedBox(height: 15),
            _buildCalendarWidget(),
            SizedBox(height: 15),
            _buildCategorySelection(),
            SizedBox(height: 20),
            _buildDailyPlanCard(),
            SizedBox(height: 20),
            _buildWorkoutList(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal.shade300,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min, // Centers the content nicely
        children: [
          Text(
            "WorkOut",
            style: TextStyle(color: Colors.white),
          ),
          Icon(Icons.fitness_center, color: Colors.white),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Row(
      children: [
        Icon(Icons.fitness_center, color: Colors.deepPurple, size: 24),
        SizedBox(width: 8),
        Text(
          "Start your Workout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCalendarWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month - 1);
                });
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DateFormat('MMMM yyyy').format(_focusedDay),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month + 1);
                });
              },
            ),
          ],
        ),
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerVisible: false,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
                color: Colors.pink.shade100, shape: BoxShape.circle),
            selectedDecoration:
                BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
            weekendTextStyle: TextStyle(color: Colors.redAccent),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
            weekendStyle:
                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          calendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          onPageChanged: (focusedDay) => _focusedDay = focusedDay,
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem("Cardio\n ", FontAwesomeIcons.running),
        _buildCategoryItem("Lift for\nStrength", FontAwesomeIcons.dumbbell),
        _buildCategoryItem("Keep\nfit", FontAwesomeIcons.spa),
      ],
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    bool isSelected = selectedCategory == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
          });
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 4)]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 24,
                  color: isSelected ? Colors.deepPurple : Colors.black),
              SizedBox(height: 5),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyPlanCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade200, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 20, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text(
                      "My Plan For Today",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    text: "1/7 ",
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "Complete",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 0.25),
            duration: Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 8,
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                  ),
                  Text(
                    "${(value * 100).toInt()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Workout Programs",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: workoutList.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            final workout = workoutList[index];
            return AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    workout["image"],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(workout["title"],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "${workout["duration"]}  |  ${workout["calories"]}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                onTap: () {
                  // Optionally navigate to detail
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            // Update state here as needed
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          elevation: 10,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: "Favorites"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined), label: "Activity"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: "Settings"),
          ],
        ),
      ),
    );
  }
}