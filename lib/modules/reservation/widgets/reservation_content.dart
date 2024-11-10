// ignore_for_file: use_build_context_synchronously
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservation_court_info.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservation_court_time.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:com.tennis.arshh/providers/instructor_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationContent extends StatefulWidget {
  const ReservationContent({
    super.key,
    required this.court,
  });
  final Courts court;

  @override
  State<ReservationContent> createState() => _ReservationContentState();
}

class _ReservationContentState extends State<ReservationContent> {
  @override
  Widget build(BuildContext context) {
    final courtsProvider = Provider.of<CourtsProvider>(context);
    final reserveProvider = Provider.of<ReserveProvider>(context);
    final instructorProvider =
        Provider.of<InstructorProvider>(context, listen: false);

    final name = widget.court.name;

    final availableDates = courtsProvider.getFilteredDates(name);
    final availableHours = courtsProvider.getFilteredHours(name);
    return Column(
      children: [
        ReservationCourtInfo(widget: widget, context: context),
        ReservationCourtTime(
            context: context,
            availableDates: availableDates,
            availableHours: availableHours,
            courtsProvider: courtsProvider,
            reserverProvider: reserveProvider,
            instructorProvider: instructorProvider,
            court: widget.court),
      ],
    );
  }
}
