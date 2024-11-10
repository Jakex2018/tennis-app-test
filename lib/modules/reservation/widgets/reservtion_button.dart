// ignore_for_file: use_build_context_synchronously
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/services/time_available.dart';
import 'package:com.tennis.arshh/providers/instructor_provider.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';

class ReservationButton extends StatelessWidget {
  const ReservationButton({
    super.key,
    required this.instructorProvider,
    required this.date,
    required this.reserverProvider,
    required this.courtId,
    required this.userId,
    required this.startTime,
    required this.endTime,
  });

  final InstructorProvider instructorProvider;
  final DateTime? date;
  final ReserveProvider reserverProvider;
  final String courtId;
  final String userId;
  final String startTime;
  final String endTime;

  @override
  Widget build(BuildContext context) {
    return ButtonOne(
      onTap: () async {
        final instructorId = instructorProvider.selectedInstructor?.id;
        if (date != null) {
          if (instructorId != null) {
            bool areTimesAvailable = await TimeAvailable().areTimesAvailable(
              reserverProvider,
              courtId,
              startTime,
              endTime,
              date!,
            );

            if (areTimesAvailable) {
              bool reserveDone =
                  await reserverProvider.addReserves(courtId, date!);
              if (reserveDone) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Deseas Reservar'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            reserverProvider.setReserveDetails(
                              userId,
                              courtId,
                              date!,
                              instructorId,
                              startTime,
                              endTime,
                              reserverProvider.commentController.text,
                            );

                            await reserverProvider.saveReserve();

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Reserva realizada con éxito!")));

                            reserverProvider.clearReserve();
                            instructorProvider.clearReserve();
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                  "Ya se han alcanzado las 3 reservas para este día",
                  style: TextStyle(
                      backgroundColor: Colors.red, color: Colors.white),
                )));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  "Las horas seleccionadas ya están reservadas. Por favor, elige otras horas.",
                  style: TextStyle(
                      backgroundColor: Colors.red, color: Colors.white),
                ),
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Debe seleccionar un instructor")));
          }
        }
      },
      title: 'Reservar',
      color: Theme.of(context).colorScheme.primary,
      width: .9,
    );
  }
}