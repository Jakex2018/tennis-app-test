import 'package:com.tennis.arshh/modules/welcome/widget/background_image.dart';
import 'package:com.tennis.arshh/modules/welcome/widget/welcome_content.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const Stack(children: [BackgroundImage(), WelcomeContent()]),
    );
  }
}
