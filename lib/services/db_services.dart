import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveUserFirebase({
    required String name,
    required String email,
    required String phone,
  }) async {
    String uid = _auth.currentUser!.uid;

    UserProfile user =
        UserProfile(uid: uid, email: email, name: name, phone: phone);

    final userMap = user.toMap();

    await _db.collection('users').doc(uid).set(userMap);
  }

  Future<UserProfile> getUserFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      throw FirebaseException(
          message: 'Error fetching user profile',
          code: 'user_profile_error',
          plugin: '');
    }
  }
}
