import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/providers/court_provider.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownBodyStart extends StatefulWidget {
  const DropdownBodyStart({
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

    return Consumer<CourtsProvider>(builder: (context, provider, child) {
      final availableHours = provider.getFilteredHours(courtId);
      final currentStartTime = context.watch<ReserveProvider>().startTime;
      final isStartTimeValid = availableHours.contains(currentStartTime);

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
            value: isStartTimeValid ? currentStartTime : null,
            hint: Text(
              widget.title,
              style: const TextStyle(fontSize: 12),
            ),
            onChanged: (value) {
              if (value != null) {
                final reserveDate =
                    context.read<ReserveProvider>().reserveDate ??
                        DateTime.now();

                bool isAvailable = context
                    .read<ReserveProvider>()
                    .isAvailableForHour(courtId, value, reserveDate);

                if (!isAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "La hora seleccionada no está disponible o está bloqueada por 24 horas",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  return;
                } else {
                  context.read<ReserveProvider>().setStartTime(value);
                  context
                      .read<ReserveProvider>()
                      .reserveHour(courtId, value, reserveDate);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Por favor, selecciona una hora de inicio")),
                );
              }
            },
            items: allHours.map((hour) {
              final reserveDate =
                  context.read<ReserveProvider>().reserveDate ?? DateTime.now();
              final isReserved = !context
                  .read<ReserveProvider>()
                  .isAvailableForHour(courtId, hour, reserveDate);
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
