import 'package:com.tennis.arshh/modules/home/widget/courts_card.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourtSlider extends StatefulWidget {
  const CourtSlider({super.key});

  @override
  State<CourtSlider> createState() => _CourtSliderState();
}

class _CourtSliderState extends State<CourtSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      constraints: const BoxConstraints(maxHeight: 410, maxWidth: 400),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 2)),
      ),
      child: Consumer<CourtsProvider>(builder: (context, courts, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            width: 15,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: courts.menu.length,
          itemBuilder: (context, index) {
            return CourtsCard(courts: courts, index: index, context: context);
          },
        );
      }),
    );
  }
}
