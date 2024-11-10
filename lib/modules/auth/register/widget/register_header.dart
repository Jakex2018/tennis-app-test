import 'package:flutter/material.dart';
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
    ]);
  }
}
