import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'public/asset/images/img_welcome.png',
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}
