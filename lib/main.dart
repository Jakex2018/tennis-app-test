import 'package:com.tennis.arshh/config/constant.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:com.tennis.arshh/providers/instructor_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:com.tennis.arshh/modules/auth/providers/user_provider.dart';
import 'package:com.tennis.arshh/screens/home_screen.dart';
import 'package:com.tennis.arshh/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
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
  late Future<void> initSession;
  @override
  void initState() {
    super.initState();
    initSession = _initializeSessionUser();
  }

  Future<void> _initializeSessionUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.initializeUser();
    await userProvider.checkUserSession();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(context),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FutureBuilder(
          future: initSession,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al iniciar sesión'));
            }
            return Consumer<UserProvider>(
                builder: (context, userProvider, child) {
              if (userProvider.isLogged) {
                return const HomeScreen();
              } else {
                return const WelcomeScreen();
              }
            });
          }),
    );
  }
}

