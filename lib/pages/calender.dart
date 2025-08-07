import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
 import 'package:intl/intl.dart';


//// important : this page views the calendar and this dats nutrients and exercises 
///   its integrating the firebase in this page cause its short and we didnt use the manager class except to get the uid easily








class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final manager = BackendManager();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<String, dynamic>? _nutrients;
  List<Map<String, dynamic>> _workouts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchDayData(_selectedDay!);
  }

  Future<void> _fetchDayData(DateTime day) async {
    setState(() => _isLoading = true);

    final nutrients = await fetchNutrientsForDay(day);
    final workouts = await fetchWorkoutsForDay(day);

    setState(() {
      _nutrients = nutrients;
      _workouts = workouts;
      _isLoading = false;
    });
  }



//get the nutrients from the firease 
  Future<Map<String, dynamic>?> fetchNutrientsForDay(DateTime selectedDay) async {
    final uid = manager.getUid();

    final doc = await FirebaseFirestore.instance
        .collection('nutrients')
        .doc(uid)
        .get();

    if (!doc.exists) return null;

    final data = doc.data();
    final DateTime nutrientDate = (data?['date'] as Timestamp).toDate();
    print("the nutrients are: $data");
    if (isSameDay(nutrientDate, selectedDay)) {
      return data;
    }

    return null;
  }




//get the workout from the fireabase
Future<List<Map<String, dynamic>>> fetchWorkoutsForDay(DateTime selectedDay) async {
  final uid = manager.getUid();
  final doc = await FirebaseFirestore.instance
      .collection('finishedWorkouts')
      .doc(uid)
      .get();

  if (!doc.exists) return [];

  final data = doc.data();
  final lastSavedStr = data?['lastSaved']; // e.g., "2025-08-07"
  final completed = List<String>.from(data?['completed'] ?? []);
  final percentage = data?['percentage'] ?? 0.0;

  // Parse lastSaved string to DateTime
  final lastSavedDate = DateTime.tryParse(lastSavedStr ?? '');
  if (lastSavedDate == null) return [];

  // Compare only the date part (ignore time)
  final isSame = isSameDay(lastSavedDate, selectedDay);

  if (isSame) {
    return completed.map((exercise) => {
      'title': exercise,
      'percentage': percentage,
    }).toList();
  }

  return [];
}






//the card template to view the data
  Widget _buildDaySummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text(value, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Calendar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchDayData(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                      color: Colors.deepPurple, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: Colors.deepPurple.shade300,
                      shape: BoxShape.circle),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),

            SizedBox(height: 30),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else ...[
              if (_nutrients != null) ...[
                _buildDaySummaryCard(
                  icon: Icons.local_fire_department,
                  title: "Calories",
                  value: "${_nutrients!['calories']} kcal",
                  color: Colors.orange,
                ),
                _buildDaySummaryCard(
                  icon: Icons.fitness_center,
                  title: "Protein",
                  value: "${_nutrients!['protein']} g",
                  color: Colors.redAccent,
                ),
                _buildDaySummaryCard(
                  icon: Icons.water_drop,
                  title: "Water",
                  value: "${_nutrients!['water']} cups",
                  color: Colors.blueAccent,
                ),
              ] else
                _buildDaySummaryCard(
                  icon: Icons.no_food,
                  title: "Nutrition",
                  value: "No data logged",
                  color: Colors.grey,
                ),

              if (_workouts.isNotEmpty) ...[
                for (var workout in _workouts)
                  _buildDaySummaryCard(
                    icon: Icons.directions_run,
                    title: workout['title'] ?? "Workout",
                    value: "Intensity: ${workout['percentage']}%",
                    color: Colors.green,
                  ),
              ] else
                _buildDaySummaryCard(
                  icon: Icons.directions_run,
                  title: "Workout",
                  value: "No workout logged",
                  color: Colors.grey,
                ),
            ],
          ],
        ),
      ),
    );
  }
}