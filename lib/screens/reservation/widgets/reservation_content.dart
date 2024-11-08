// ignore_for_file: use_build_context_synchronously

import 'package:com.tennis.arshh/common/dropdown_body.dart';
import 'package:com.tennis.arshh/common/dropdown_body.end.dart';
import 'package:com.tennis.arshh/common/dropdown_body_date.dart';
import 'package:com.tennis.arshh/common/dropdown_body_start.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/instructors.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:com.tennis.arshh/model/user.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        reservationCourtInfo(context),
        reservationCourtTime(context, availableDates, availableHours,
            courtsProvider, reserveProvider, instructorProvider, widget.court),
      ],
    );
  }

  Container reservationCourtTime(
      BuildContext context,
      List<DateTime> availableDates,
      List<String> availableHours,
      CourtsProvider courtsProvider,
      ReserveProvider reserverProvider,
      InstructorProvider instructorProvider,
      Courts court) {
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
            ButtonOne(
                onTap: () async {
                  final instructorId =
                      instructorProvider.selectedInstructor?.id;
                  if (date != null) {
                    if (instructorId != null) {
                      //VERIFICAR SI SE PUEDE RESERVAR
                      bool reserveDone =
                          await reserverProvider.addReserves(courtId, date);
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
                                        date,
                                        instructorId,
                                        startTime,
                                        endTime,
                                        reserverProvider
                                            .commentController.text);
                                    //GUARDAR RESERVA
                                    await reserverProvider.saveReserve();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Reserva realizada con éxito!")));
                                    //LIMPIAR FORMULARIO
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          "Ya se han alcanzado las 3 reservas para este día",
                          style: TextStyle(
                              backgroundColor: Colors.red, color: Colors.white),
                        )));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Debe seleccionar un instructor")));
                    }
                  }
                },
                title: 'Reservar',
                color: Theme.of(context).colorScheme.primary,
                width: .9)
          ],
        ));
  }

  Container reservationCourtInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.27,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.court.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.court.typeCourt,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.court.timePlay,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                      ),
                      Text(
                        widget.court.direction,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownBody(
                    provider: InstructorProvider(),
                    height: 40,
                    width: .4,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${widget.court.price.toString()}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'Por Hora',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_queue_rounded,
                        size: 15,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('${widget.court.temp.toString()}%'),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}




/*
// ignore_for_file: use_build_context_synchronously

import 'package:com.tennis.arshh/common/dropdown_body.dart';
import 'package:com.tennis.arshh/common/dropdown_body.end.dart';
import 'package:com.tennis.arshh/common/dropdown_body_date.dart';
import 'package:com.tennis.arshh/common/dropdown_body_start.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/instructors.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:com.tennis.arshh/model/user.dart';
import 'package:com.tennis.arshh/widget/button_one.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        reservationCourtInfo(context),
        reservationCourtTime(context, availableDates, availableHours,
            courtsProvider, reserveProvider, instructorProvider, widget.court),
      ],
    );
  }

  Container reservationCourtTime(
      BuildContext context,
      List<DateTime> availableDates,
      List<String> availableHours,
      CourtsProvider courtsProvider,
      ReserveProvider reserverProvider,
      InstructorProvider instructorProvider,
      Courts court) {
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
                  title: startTime.isNotEmpty ? startTime : 'No disponible',
                  availableHours: availableHours,
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownBodyEnd(
                  width: .40,
                  height: 50,
                  title: endTime.isNotEmpty ? endTime : 'No disponible',
                  availableHours: availableHours,
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
            ButtonOne(
                onTap: () async {
                  final instructorId =
                      instructorProvider.selectedInstructor?.id;
                  if (date != null) {
                    if (instructorId != null) {
                      //VERIFICAR SI SE PUEDE RESERVAR
                      bool reserveDone =
                          await reserverProvider.addReserves(courtId, date);
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
                                        date,
                                        instructorId,
                                        startTime,
                                        endTime,
                                        reserverProvider
                                            .commentController.text);
                                    //GUARDAR RESERVA
                                    await reserverProvider.saveReserve();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Reserva realizada con éxito!")));
                                    //LIMPIAR FORMULARIO
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          "Ya se han alcanzado las 3 reservas para este día",
                          style: TextStyle(
                              backgroundColor: Colors.red, color: Colors.white),
                        )));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Debe seleccionar un instructor")));
                    }
                  }
                },
                title: 'Reservar',
                color: Theme.of(context).colorScheme.primary,
                width: .9)
          ],
        ));
  }

  Container reservationCourtInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.27,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.court.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.court.typeCourt,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.court.timePlay,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                      ),
                      Text(
                        widget.court.direction,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownBody(
                    provider: InstructorProvider(),
                    height: 40,
                    width: .4,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${widget.court.price.toString()}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'Por Hora',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_queue_rounded,
                        size: 15,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('${widget.court.temp.toString()}%'),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}



 */