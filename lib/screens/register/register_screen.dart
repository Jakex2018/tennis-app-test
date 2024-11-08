import 'package:com.tennis.arshh/screens/login/login_screen.dart';
import 'package:com.tennis.arshh/screens/register/widget/form_register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Image.asset('public/asset/images/img_auth.png'),
                Positioned(
                    top: 40,
                    left: 30,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))))
              ]),
              const FormRegister(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
      ),
    ));
  }
}
