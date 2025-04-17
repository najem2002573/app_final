import 'package:hive/hive.dart';

part 'appUser.g.dart';

@HiveType(typeId: 2)
class AppUser extends HiveObject {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  bool isSignedIn;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    this.isSignedIn = false,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
  return AppUser(
    uid: uid,
    username: map['username'] ?? '',
    email: map['email'] ?? '',
    isSignedIn: map['isSignedIn'] ?? true, // fallback to true
  );
}

  void SetIsSignedIn(bool val){this.isSignedIn=val;}

  Map<String, dynamic> toMap() {
  return {
    'username': username,
    'email': email,
    'isSignedIn': isSignedIn, // 👈 ADD THIS!
  };
}
}
