import 'package:com.tennis.arshh/modules/auth/services/auth.services.dart';
import 'package:flutter/material.dart';

class AppbarContent extends StatelessWidget implements PreferredSizeWidget {
  const AppbarContent({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
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
            ],
          ),
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
                      colors: <Color>[Color(0xFF82BC00), Color(0xFFAAF724)],
                    ),
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
                      LoginServices().logout(context);
                      
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

  @override
  Size get preferredSize =>
      const Size.fromHeight(80);
}
