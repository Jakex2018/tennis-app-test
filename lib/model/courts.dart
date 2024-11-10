import 'package:flutter/material.dart';

class Courts extends ChangeNotifier {
  final String id;
  final String name;
  final String timePlay;
  final String typeCourt;
  final String date;
  final String image;
  final int price;
  final int minimumDuration;
  final String direction;
  final bool isAvailable;
  double latitude;
  double longitude;
  final List<DateTime> availableDates = [
    DateTime(2024, 7, 9),
    DateTime(2024, 7, 10),
    DateTime(2024, 7, 11),
    DateTime(2024, 7, 12),
    DateTime(2024, 7, 13),
  ];
  final List<String> allHours;
  final List<bool> isAvailableForHour;

  Courts(
      {required this.timePlay,
      required this.latitude,
      required this.longitude,
      required this.allHours,
      required this.id,
      required this.isAvailableForHour,
      this.isAvailable = true,
      required this.direction,
      required this.price,
      required this.minimumDuration,
      required this.typeCourt,
      required this.date,
      required this.name,
      required this.image});
}
