import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class UserProvider extends ChangeNotifier {
  String _userName = '';
  String get userName => _userName;

  User? _user;
  User? get user => _user;

  bool _isLogged = false;
  bool get isLogged => _isLogged;

  String? _userId;
  String? get userId => _userId;

  // AUTHENTICACTION

  Future<void> initializeUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _loadUserFromPreferences(user.uid);
      notifyListeners();
    }
  }

  Future<void> checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null) {
      _isLogged = true;
      notifyListeners();
    } else {
      _isLogged = false;
      notifyListeners();
    }
  }

  Future<void> saveUserToPreferences(
      String uid, String email, String name) async {
    try {
      // Guardamos la información del usuario en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
      await prefs.setString('email', email);
      await prefs.setString('name', name);

      // Actualizamos las propiedades locales
      _userName = name;
      _isLogged = true;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  Future<void> _loadUserFromPreferences(String uid) async {
    try {
      // Recuperamos el nombre del usuario desde Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _userName = userDoc[
            'name']; // Asegúrate de que 'name' esté en tu documento de Firestore
        notifyListeners();
      }
    } catch (e) {
      print("Error al obtener el nombre del usuario: $e");
    }
  }

   Future<void> loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    final name = prefs.getString('name') ?? 'Usuario';

    if (uid != null) {
      _userName = name;
      _isLogged = true;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid'); // Elimina el UID
      await prefs.remove('email'); // Elimina el correo electrónico
      await prefs.remove('name'); // Elimina el nombre

      _userName = '';
      _user = null; // Limpia el objeto User
      _isLogged = false; // Actualiza el estado de sesión
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
