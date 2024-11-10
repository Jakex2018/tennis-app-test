import 'package:flutter/material.dart';

class BottomNavBarShadow extends StatefulWidget {
  const BottomNavBarShadow({super.key});

  @override
  State<BottomNavBarShadow> createState() => _BottomNavBarShadowState();
}

class _BottomNavBarShadowState extends State<BottomNavBarShadow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: bottomNavBar(),
    );
  }
  TabBar bottomNavBar() {
    return TabBar(
        dividerHeight: 70,
        dividerColor: Colors.white,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary,
        ),
        splashBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        labelPadding: const EdgeInsets.all(20),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.home,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
          ),
        ]);
  }
}
