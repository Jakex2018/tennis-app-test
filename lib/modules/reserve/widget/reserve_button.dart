import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';

class ReserveButton extends StatelessWidget {
  const ReserveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonOne(
        fontSize: 20,
        title: 'Programar reserva',
        color: Theme.of(context).colorScheme.primary,
        width: .9);
  }
}
