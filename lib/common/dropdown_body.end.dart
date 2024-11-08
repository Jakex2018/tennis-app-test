import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DropdownBodyEnd extends StatefulWidget {
  const DropdownBodyEnd({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    this.availableHours,
    this.onChanged,
    required this.court,
  });

  final double width;
  final double height;
  final String title;
  final List<String>? availableHours;
  final Function(String?)? onChanged;
  final Courts court;

  @override
  State<DropdownBodyEnd> createState() => _DropdownBodyEndState();
}

class _DropdownBodyEndState extends State<DropdownBodyEnd> {
  DateTime convertToDateTime(String hour) {
    final now = DateTime.now();
    try {
      if (hour.contains('AM') || hour.contains('PM')) {
        final parsedTime = DateFormat('hh:mm a').parse(hour);
        return DateTime(
            now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
      } else {
        final timePart = hour.split(':');
        return DateTime(now.year, now.month, now.day, int.parse(timePart[0]),
            int.parse(timePart[1]));
      }
    } catch (e) {
      throw FormatException('Invalid time format: $hour');
    }
  }

  @override
  Widget build(BuildContext context) {
    final courtId = widget.court.id;
    return Consumer<CourtsProvider>(
      builder: (context, provider, child) {
        final availableHours = provider.getFilteredHours(courtId);
        final currentEndTime = context.watch<ReserveProvider>().endTime;
        final isEndTimeValid = availableHours.contains(currentEndTime);

        final allHours =
            provider.menu.firstWhere((court) => court.id == courtId).allHours;
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: isEndTimeValid ? currentEndTime : null,
              hint: Text(
                widget.title,
                style: const TextStyle(fontSize: 12),
              ),
              onChanged: (value) {
                final start = context.read<ReserveProvider>().startTime;
                if (start != null && start.isNotEmpty && value != null) {
                  try {
                    DateTime startDateTime = convertToDateTime(start);
                    DateTime endDateTime = convertToDateTime(value);

                    if (endDateTime.isBefore(startDateTime) ||
                        endDateTime.isAtSameMomentAs(startDateTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "La hora de finalización no puede ser anterior a la hora de inicio"),
                        ),
                      );
                      return;
                    }

                    // Marcar la hora como ocupada en el CourtsProvider
                    provider.reserveHour(courtId, value);
                    context.read<ReserveProvider>().setEndTime(value);
                  } catch (e) {
                    return;
                  }
                } else {
                  // Si la hora de inicio no está seleccionada, mostrar mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Por favor, selecciona primero una hora de inicio"),
                    ),
                  );
                }
              },
              items: allHours.map((hour) {
                // Encuentra la hora en isAvailableForHour
                final hourIndex = provider.menu
                    .firstWhere((court) => court.id == courtId)
                    .allHours
                    .indexOf(hour);
                final isReserved = hourIndex != -1 &&
                    !provider.menu
                        .firstWhere((court) => court.id == courtId)
                        .isAvailableForHour[hourIndex];
                final isSelected =
                    context.watch<ReserveProvider>().startTime == hour;
                return DropdownMenuItem<String>(
                  value: hour,
                  child: Text(
                    hour,
                    style: TextStyle(
                      fontSize: 12,
                      decoration: isReserved || isSelected
                          ? TextDecoration.lineThrough
                          : null,
                      color:
                          isReserved || isSelected ? Colors.grey : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

/*
class DropdownBodyEnd extends StatefulWidget {
  const DropdownBodyEnd(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      this.availableHours});

  final double width;
  final double height;
  final String title;

  final List<String>? availableHours;

  @override
  State<DropdownBodyEnd> createState() => _DropdownBodyEndState();
}

class _DropdownBodyEndState extends State<DropdownBodyEnd> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CourtsProvider>(builder: (context, provider, child) {
      final court = provider;
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: court.selectedCourtEnd,
            hint: Text(
              widget.title,
              style: const TextStyle(fontSize: 12),
            ),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  court.setSelectedCourtEnd(newValue);
                });
              }
            },
            items: widget.availableHours?.map((hour) {
              return DropdownMenuItem<String>(
                value: hour,
                child: Text(
                  hour,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}

 */