import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownBodyStart extends StatefulWidget {
  const DropdownBodyStart(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      this.availableHours,
      this.onChanged,
      required this.court});

  final double width;
  final double height;
  final String title;
  final Courts court;
  final Function(String?)? onChanged;

  final List<String>? availableHours;

  @override
  State<DropdownBodyStart> createState() => _DropdownBodyStartState();
}

class _DropdownBodyStartState extends State<DropdownBodyStart> {
  @override
  Widget build(BuildContext context) {
    final courtId = widget.court.id;
    print('COURTID $courtId');
    return Consumer<CourtsProvider>(builder: (context, provide, child) {
      final availableHours = provide.getFilteredHours(courtId);

      final currentStartTime = context.watch<ReserveProvider>().startTime;
      final isStartTimeValid = availableHours.contains(currentStartTime);

      final allHours =
          provide.menu.firstWhere((court) => court.id == courtId).allHours;
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: isStartTimeValid ? currentStartTime : null,
            hint: Text(
              widget.title,
              style: const TextStyle(fontSize: 12),
            ),
            onChanged: (value) {
              if (value != null) {
                // Reservar la hora seleccionada
                provide.reserveHour(courtId, value);
                context.read<ReserveProvider>().setStartTime(value);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Por favor, selecciona una hora de inicio")),
                );
              }
            },
            items: allHours.map((hour) {
              final hourIndex = provide.menu
                  .firstWhere((court) => court.id == courtId)
                  .allHours
                  .indexOf(hour);
              final isReserved = hourIndex != -1 &&
                  !provide.menu
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
    });
  }
}


/*
class DropdownBodyStart extends StatefulWidget {
  const DropdownBodyStart(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      this.availableHours, this.onChanged});

  final double width;
  final double height;
  final String title;
  final Function(String?)? onChanged;

  final List<String>? availableHours;

  @override
  State<DropdownBodyStart> createState() => _DropdownBodyStartState();
}

class _DropdownBodyStartState extends State<DropdownBodyStart> {
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
            value: court.selectedCourtStart,
            hint: Text(
              widget.title,
              style: const TextStyle(fontSize: 12),
            ),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  court.setSelectedCourtStart(newValue);
                 
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