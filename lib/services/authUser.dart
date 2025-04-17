import 'package:app/services/appUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box=Hive.box<AppUser>('userBox');
  
  // Register
  Future<AppUser?> registerUser(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user=result.user;
      if (user !=null)
        SaveUserData(user, username);
      final uid = result.user!.uid;

      // Save extra user data to Firestore
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now(),
      });
      print("USER HAS BEEN REGISTERED FOR THE FIRST TIME");
      
      return AppUser(uid: uid, username: username, email: email, isSignedIn: true);
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // Sign In
  Future<AppUser?> signInUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) return null;

      return AppUser.fromMap(uid, doc.data()!);
    } catch (e) {
      print('Sign-in error: $e');
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current signed in user
  AppUser? getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      return AppUser(uid: user.uid, username: '', email: user.email ?? '', isSignedIn: true);
    }
    return null;
  }

  Future<void> SaveUserData(User user, String userName) async {
  try {
    
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': userName,
      'email': user.email,
      'joinedAt': DateTime.now().toIso8601String(),
    });
    
    print("✅ User data saved successfully!");
  } catch (e) {
    print("❌ Failed to save user data: $e");
  }
}

}
