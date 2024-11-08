import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DropdownBodyDate extends StatefulWidget {
  const DropdownBodyDate({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.availableDate,
  });

  final double width;
  final double height;
  final String title;
  final List<DateTime> availableDate;

  @override
  State<DropdownBodyDate> createState() => _DropdownBodyDateState();
}

class _DropdownBodyDateState extends State<DropdownBodyDate> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReserveProvider>(builder: (context, provider, child) {
      final reserve = provider;

      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<DateTime>(
            value: reserve.reserveDate,
            hint: Text(
              widget.title,
              style: const TextStyle(fontSize: 12),
            ),
            onChanged: (DateTime? newValue) {
              if (newValue != null) {
                reserve.setDateTime(newValue);
              }
            },
            items: widget.availableDate.map((hour) {
              return DropdownMenuItem<DateTime>(
                // Establecer el tipo como DateTime
                value: hour, // Pasamos la fecha directamente
                child: Text(
                  DateFormat('d MMMM y').format(hour),
                  style: const TextStyle(fontSize: 12),
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
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DropdownBodyDate extends StatefulWidget {
  const DropdownBodyDate({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.availableDate,
  });

  final double width;
  final double height;
  final String title;
  final List<DateTime> availableDate;

  @override
  State<DropdownBodyDate> createState() => _DropdownBodyDateState();
}

class _DropdownBodyDateState extends State<DropdownBodyDate> {
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
          child: DropdownButton<DateTime>(
            value: court.selectedCourtDate,
            hint: Text(
              widget.title,
              style: const TextStyle(fontSize: 12),
            ),
            onChanged: (DateTime? newValue) {
              if (newValue != null) {
                setState(() {
                  court.setSelectedCourtDate(newValue);
                });
              }
            },
            items: widget.availableDate.map((hour) {
              return DropdownMenuItem<DateTime>(
                // Establecer el tipo como DateTime
                value: hour, // Pasamos la fecha directamente
                child: Text(
                  DateFormat('d MMMM y').format(hour),
                  style: const TextStyle(fontSize: 12),
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