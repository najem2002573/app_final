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




////// THE AUTOMATIC UPLOAD
Future<void> uploadWorkoutsToPlans() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, List<Map<String, dynamic>>> categorizedWorkouts = {
    'keep_fit': [
      {
        "name": "Keep fit",
        "duration": 60,
        "exercises": [
          "Bodyweight Squats", "Push-ups", "Plank", "Lunges", "Jumping Jacks",
          "Mountain Climbers", "Superman Hold", "Tricep Dips", "Bicycle Crunches",
          "Glute Bridges", "Wall Sit", "Step-Ups"
        ]
      }
    ],
    'lift_for_strength': [
      {
        "name": "Chest Day",
        "duration": 50,
        "exercises": [
          "Bench Press", "Incline Dumbbell Press", "Cable Crossover", "seated cable fly",
          "Chest Dips", "Decline Bench Press", "Push-Ups"
        ]
      },
      {
        "name": "Back Day",
        "duration": 50,
        "exercises": [
          "Lat Pulldown", "Pull-Ups (Wide Grip)", "Barbell Deadlift", "Bent-Over Barbell Row",
          "Seated Cable Row", "T-Bar Row", "Straight Arm Pulldown"
        ]
      },
      {
        "name": "Leg Day",
        "duration": 50,
        "exercises": [
          "Barbell Back Squat", "Romanian Deadlift", "Walking Lunges", "seated cable fly",
          "Bulgarian Split Squat", "Leg Curl", "Standing Calf Raises"
        ]
      },
      {
        "name": "Biceps Day",
        "duration": 40,
        "exercises": [
          "Barbell Curl", "Dumbbell Alternating Curl", "Hammer Curl", "Preacher Curl",
          "Concentration Curl", "Cable Curl (Low Pulley)", "Incline Dumbbell Curl"
        ]
      },
      {
        "name": "Triceps Day",
        "duration": 40,
        "exercises": [
          "Close-Grip Bench Press", "Triceps Dips (Bodyweight or Weighted)",
          "Skull Crushers (Lying Triceps Extensions)", "Overhead Dumbbell Triceps Extension",
          "Triceps Pushdown (Cable - Rope or Bar)", "Dumbbell Kickbacks", "Diamond Push-Ups"
        ]
      },
      {
        "name": "Sholder Day",
        "duration": 40,
        "exercises": [
          "Overhead Press", "Lateral Raises", "Front Dumbbell Raises", "Rear Delt Fly",
          "Arnold Press", "Upright Rows", "Face Pulls"
        ]
      },
      {
        "name": "Abs Day",
        "duration": 30,
        "exercises": [
          "Hanging Leg Raises", "Cable Crunches", "Russian Twists", "Plank",
          "Bicycle Crunches", "V-Ups", "Mountain Climbers"
        ]
      },
      {
        "name": "Full body Day",
        "duration": 90,
        "exercises": [
          "Barbell Squats", "Walking Lunges", "Deadlifts", "Bench Press",
          "Overhead Press", "Dips", "Barbell Curls", "Hanging Leg Raises", "Plank"
        ]
      }
    ],
    'cardio': [
      {
        "name": "Cardio Day",
        "duration": 60,
        "exercises": [
          "Jump Rope", "High Knees", "Burpees", "Mountain Climbers", "Jumping Jacks",
          "Skater Hops", "Butt Kicks", "Stair Running", "Sprint Intervals",
          "Rowing Machine", "Jump Squats", "Shadow Boxing"
        ]
      }
    ]
  };

  for (var category in categorizedWorkouts.keys) {
    final workouts = categorizedWorkouts[category]!;

    for (var workout in workouts) {
      final workoutId = workout["name"].toString().toLowerCase().replaceAll(" ", "_");

      await _firestore
          .collection('workouts')
          .doc(category)
          .collection('plans')
          .doc(workoutId)
          .set(workout);

      print('✅ Uploaded ${workout["name"]} to workouts/$category/plans/$workoutId');
    }
  }

  print('🚀 All workouts uploaded to plans subcollections!');
}







}
