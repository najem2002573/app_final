import 'package:hive/hive.dart';

part 'userDATA.g.dart';

@HiveType(typeId: 3) // Give it a unique typeId (must be different from AppUser's)
class Userdata extends HiveObject {
  @HiveField(0)
  String uid;

  @HiveField(1)
  int age;

  @HiveField(2)
  String goal;

  @HiveField(3)
  String gender;

  @HiveField(4)
  double height;

  @HiveField(5)
  double weight;

  @HiveField(6)
  String activityLevel;

  Userdata({
    required this.uid,
    required this.age,
    required this.goal,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });
}
