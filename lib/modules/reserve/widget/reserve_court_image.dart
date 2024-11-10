import 'package:com.tennis.arshh/modules/reserve/widget/reverse_card.dart';
import 'package:flutter/material.dart';

class ReverseCourtImage extends StatelessWidget {
  const ReverseCourtImage({
    super.key,
    required this.widget,
  });

  final ReverseCard widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          widget.courtDetails['image'],
          height: 60,
          width: 60,
          fit: BoxFit.cover,
        ));
  }
}

