// ignore_for_file: use_build_context_synchronously

import 'package:com.tennis.arshh/modules/reservation/widgets/dropdown_body.end.dart';
import 'package:com.tennis.arshh/common/dropdown_body_date.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/dropdown_body_start.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/modules/auth/providers/user_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/widgets/reservtion_button.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:com.tennis.arshh/providers/instructor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReservationCourtTime extends StatelessWidget {
  const ReservationCourtTime({
    super.key,
    required this.context,
    required this.availableDates,
    required this.availableHours,
    required this.courtsProvider,
    required this.reserverProvider,
    required this.instructorProvider,
    required this.court,
  });

  final BuildContext context;
  final List<DateTime> availableDates;
  final List<String> availableHours;
  final CourtsProvider courtsProvider;
  final ReserveProvider reserverProvider;
  final InstructorProvider instructorProvider;
  final Courts court;

  @override
  Widget build(BuildContext context) {
    String startTime = reserverProvider.startTime ?? 'Hora no definida';
    String endTime = reserverProvider.endTime ?? 'Hora no definida';
    String userId =
        Provider.of<UserProvider>(context).userId ?? 'No disponible';

    final courtId = court.id;

    DateTime? date = reserverProvider.reserveDate;

    return Container(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFFF4F7FC),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Establecer fecha y hora',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownBodyDate(
              width: .9,
              height: 50,
              title: date != null
                  ? DateFormat('d MMMM y').format(date)
                  : 'No disponible',
              availableDate: availableDates,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownBodyStart(
                  width: .45,
                  height: 50,
                  court: court,
                  title: startTime.isNotEmpty ? startTime : 'No disponible',
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownBodyEnd(
                  width: .40,
                  height: 50,
                  title: endTime.isNotEmpty ? endTime : 'No disponible',
                  court: court,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Agregar Comentario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: reserverProvider.commentController,
              minLines: 4,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Agregar un Comentario...',
                labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
              ),
            ),
            const Spacer(),
            ReservationButton(
                instructorProvider: instructorProvider,
                date: date,
                reserverProvider: reserverProvider,
                courtId: courtId,
                userId: userId,
                startTime: startTime,
                endTime: endTime)
          ],
        ));
  }
}
