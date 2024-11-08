// ignore_for_file: use_build_context_synchronously

import 'package:com.tennis.arshh/model/user.dart';
import 'package:com.tennis.arshh/screens/home/widget/body_page.dart';
import 'package:com.tennis.arshh/screens/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 

  @override
  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Llama al método logout del UserProvider
      await userProvider.logout();

      // Opcional: Mostrar un mensaje de SnackBar después del logout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada con éxito')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: appBarContent(context, logout),
          body: const BodyPage(),
          bottomNavigationBar: bottomNavBarShadow()),
    );
  }

  Container bottomNavBarShadow() {
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

  AppBar appBarContent(context, logout) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xFF346BC3),
                Color(0xFF82BC00),
                Color(0xFFAAF724)
              ]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Tennis',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 80,
                  height: 30,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Color(0xFF82BC00), Color(0xFFAAF724)]),
                  ),
                  child: const Text(
                    'Court',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'public/asset/images/avatar.png',
                  fit: BoxFit.cover,
                  height: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'logout') {
                      logout(context); // Llamamos a la función de logout
                    }
                  },
                  icon: const Icon(Icons.menu_outlined,
                      color: Colors.white, size: 30),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Cerrar sesión'),
                      ),
                    ];
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
