import 'package:com.tennis.arshh/common/button_icon.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset('public/asset/images/img_auth.png'),
      const Positioned(top: 40, left: 30, child: ButtonIcon())
    ]);
  }
}
