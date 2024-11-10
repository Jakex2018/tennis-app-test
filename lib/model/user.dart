import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String phone;
  final String name;

  UserProfile({
    required this.phone,
    required this.uid,
    required this.email,
    required this.name,
  });

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      email: doc['email'],
      phone: doc['phone'],
      name: doc['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name, 'phone': phone};
  }
}

