import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _userName = '';
  String get userName => _userName;

  User? _user;
  User? get user => _user;

  bool _isLogged = false;
  bool get isLogged => _isLogged;

  String? _userId;
  String? get userId => _userId;

  void setLoggedIn(bool loggedIn) {
    _isLogged = loggedIn;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners(); 
  }

  Future<void> initializeUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await loadUserFromPreferences(user.uid);
      notifyListeners();
    }
  }

  Future<void> checkUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null) {
      _isLogged = true;
    } else {
      _isLogged = false;
    }
    notifyListeners();
  }

  Future<void> saveUserToPreferences(
      String uid, String email, String name) async {
    try {
   
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
      await prefs.setString('email', email);
      await prefs.setString('name', name);

   
      _userName = name;
      _isLogged = true;
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> loadUserFromPreferences(String uid) async {
    try {
     
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _userName = userDoc[
            'name']; 
        notifyListeners();
      }
    } catch (e) {
      return;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid'); // Elimina el UID
      await prefs.remove('email'); // Elimina el correo electrónico
      await prefs.remove('name'); // Elimina el nombre

      _userName = '';
      _user = null;
      _isLogged = false; 
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  String? getUserName(String userId) {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? 'Usuario desconocido';
  }
}