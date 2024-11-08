import 'package:com.tennis.arshh/constant.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/instructors.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:com.tennis.arshh/model/user.dart';
import 'package:com.tennis.arshh/screens/home/home_screen.dart';
import 'package:com.tennis.arshh/screens/welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import the generated file
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ReserveProvider()),
    ChangeNotifierProvider(create: (context) => CourtsProvider()),
    ChangeNotifierProvider(create: (context) => InstructorProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Inicializa el UserProvider después de que el árbol de widgets se haya construido
      Provider.of<UserProvider>(context, listen: false).initializeUser();
    });

    _checkSession();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkSession() async {
    // Usamos el UserProvider para verificar si el usuario está logueado
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.checkUserSession();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(context),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Consumer<UserProvider>(builder: (context, userProvider, child) {
        if (userProvider.isLogged==true) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      }),
    );
  }
}
