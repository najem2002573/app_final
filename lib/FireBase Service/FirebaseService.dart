import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTestWorkout() async {
    try {
      await _firestore.collection('workout').add({
        'name': 'Test Workout',
        'duration': 30,
        'date': DateTime.now(),
        'exercises': ['Squats', 'Pushups', 'Plank']
      });
      print('Workout added!');
    } catch (e) {
      print("🔥 Error adding workout: $e");
    }
  }

  Future<void> getWorkouts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('workouts').get();
      for (var doc in snapshot.docs) {
        print('Workout: ${doc.data()}');
      }
    } catch (e) {
      print('Error retrieving workouts: $e');
    }
  }
}
