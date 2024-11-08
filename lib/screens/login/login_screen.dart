import 'package:com.tennis.arshh/common/button_icon.dart';
import 'package:com.tennis.arshh/screens/login/widget/form_body.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Image.asset('public/asset/images/img_auth.png'),
              const Positioned(
                  top: 40,
                  left: 30,
                  child: ButtonIcon())
            ]),
            const FormBody(),
          ],
                ),
              ),
        ));
  }
}
