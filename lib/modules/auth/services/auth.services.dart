// ignore_for_file: use_build_context_synchronously
/*
   User? getCurrentUser() => _auth.currentUser;
  String getCurrentId() => _auth.currentUser?.uid ?? '';
   */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/user.dart';
import 'package:com.tennis.arshh/modules/auth/providers/user_provider.dart';
import 'package:com.tennis.arshh/screens/home_screen.dart';
import 'package:com.tennis.arshh/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginServices {
  final _auth = FirebaseAuth.instance;

  void showSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.green}) {
    // Usamos addPostFrameCallback para asegurarnos de que el Scaffold está disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackbar = SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(bottom: 50, left: 60, right: 50),
        backgroundColor: backgroundColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });
  }

  Future<UserCredential?> loginUser(
      String email, String password, BuildContext context) async {
    try {
      final loginCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = loginCredential.user;

      if (loginCredential.user != null) {
        final userDocument = await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get();
        if (userDocument.exists) {
          // Extraemos el nombre del usuario desde el documento de Firestore
          String name = userDocument.data()?['name'] ?? 'Usuario';

          // Guardamos el nombre y otros datos en SharedPreferences
          await Provider.of<UserProvider>(context, listen: false)
              .saveUserToPreferences(user!.uid, user.email!, name);

          // También actualizamos el nombre en el UserProvider
          Provider.of<UserProvider>(context, listen: false).setUserName(name);

          // Mostrar mensaje de login exitoso
          showSnackBar(context, 'Inicio de sesion exitoso',
              backgroundColor: Colors.green);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'La dirección de correo electrónico no está registrada.';
      } else if (e.code == 'wrong-password') {
        message = 'La contraseña es incorrecta.';
      } else {
        message = 'Ocurrió un error durante el inicio de sesión.';
      }
      var snackbar = SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(bottom: 50, left: 60, right: 50),
        backgroundColor: const Color.fromARGB(255, 12, 165, 53),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    return null;
  }

  Future<UserCredential?> registerUser(String name, String email,
      String password, String confirm, String phone, context) async {
    try {
    
      if (name.isEmpty) {
        name = 'Usuario';
      }
     
      if (password != confirm) {
        var snackbar = const SnackBar(
          content: Text('Contraseñas no coinciden',
              style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 60),
          backgroundColor: Color.fromARGB(255, 255, 0, 0), // Rojo para error
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return null;
      }
     
      if (email.isEmpty) {
        var snackbar = const SnackBar(
          content:
              Text('Ingresa tu email', style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 60),
          backgroundColor: Color.fromARGB(255, 255, 0, 0), // Rojo para error
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return null;
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
          .hasMatch(email)) {
        var snackbar = const SnackBar(
          content: Text('Ingresa un email valido',
              style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 60),
          backgroundColor: Color.fromARGB(255, 255, 0, 0), 
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return null;
      }
   
      if (phone.isEmpty) {
        var snackbar = const SnackBar(
          content: Text('Ingresa tu número de teléfono',
              style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 60),
          backgroundColor: Color.fromARGB(255, 255, 0, 0), 
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return null;
      }

     
      if (password.isEmpty) {
        var snackbar = const SnackBar(
          content: Text('Ingresa tu contraseña',
              style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 60),
          backgroundColor: Color.fromARGB(255, 255, 0, 0), 
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return null;
      } else if (password.length < 6) {
        var snackbar = const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres',
              style: TextStyle(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 60),
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        return null;
      }

     
      final registerCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (registerCredential.user != null) {
        final User? user = registerCredential.user;
        final userId = user?.uid;
        final emailUser = user?.email ?? 'No email';
        final userModel = UserProfile(
          phone: phone,
          uid: userId!,
          email: emailUser,
          name: name,
        );

        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);
        await userDoc.set(userModel.toMap(), SetOptions(merge: true));

        await registerCredential.user?.updateDisplayName(name);

        await Provider.of<UserProvider>(context, listen: false)
            .saveUserToPreferences(user!.uid, user.email!, name);

       
        Provider.of<UserProvider>(context, listen: false).setUserName(name);
        var snackbar = const SnackBar(
          content: Text('Registro exitoso',
              style: TextStyle(color: Color.fromARGB(255, 9, 9, 9))),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
          margin: EdgeInsets.only(bottom: 50, left: 60, right: 50),
          backgroundColor: Color.fromARGB(255, 12, 165, 53),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'La dirección de correo electrónico no está registrada.';
      } else if (e.code == 'wrong-password') {
        message = 'La contraseña es incorrecta.';
      } else {
        message = 'Ocurrió un error durante el inicio de sesión.';
      }
      var snackbar = SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(bottom: 50, left: 60, right: 50),
        backgroundColor: const Color.fromARGB(255, 12, 165, 53),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return null;
    }
    return null;
  }

  Future<void> logout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.logout();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }
}