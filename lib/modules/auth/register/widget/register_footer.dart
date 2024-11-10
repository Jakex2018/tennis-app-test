import 'package:com.tennis.arshh/screens/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
class RegisterFooter extends StatelessWidget {
  const RegisterFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80, bottom: 10),
      child: RichText(
          text: TextSpan(
              text: 'Ya tengo cuenta  ',
              style: const TextStyle(color: Colors.grey),
              children: <TextSpan>[
            TextSpan(
                text: 'Iniciar Sesion',
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen())),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ))
          ])),
    );
  }
}
