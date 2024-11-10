// ignore_for_file: use_build_context_synchronously
import 'package:com.tennis.arshh/modules/home/widget/app_bar_content.dart';
import 'package:com.tennis.arshh/modules/home/widget/body_page.dart';
import 'package:com.tennis.arshh/modules/home/widget/bottom_nav_bar_shadow.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppbarContent(),
          body: BodyPage(),
          bottomNavigationBar: BottomNavBarShadow()),
    );
  }
}
