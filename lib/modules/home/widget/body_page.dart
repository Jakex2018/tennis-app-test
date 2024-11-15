import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:com.tennis.arshh/screens/favorites_screen.dart';
import 'package:com.tennis.arshh/modules/home/widget/home_body.dart';
import 'package:com.tennis.arshh/screens/reserve_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // Cargar los favoritos desde SharedPreferences cuando se inicia
      Provider.of<ReserveProvider>(context, listen: false)
          .loadFavoritesFromPrefs(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const TabBarView(
        children: [HomeBody(), ReserveScreen(), FavoritesScreen()],
      ),
    );
  }
}
