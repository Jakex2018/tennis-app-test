import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservation_content.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservation_image.dart';
import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.court});
  final Courts court;
  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReservationImage(court: widget.court),
                ReservationContent(court: widget.court,)
              ],
            ),
          ),
        ));
  }
}

