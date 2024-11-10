import 'package:com.tennis.arshh/screens/login_screen.dart';
import 'package:com.tennis.arshh/screens/register_screen.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('public/asset/icons/LOGO.svg'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        ButtonOne(
                          width: .9,
                          title: 'Iniciar Sesion',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonOne(
                          width: .9,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          title: 'Registrarme',
                          color: Theme.of(context).colorScheme.inversePrimary,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}