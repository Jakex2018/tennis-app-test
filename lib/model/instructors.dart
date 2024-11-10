import 'package:flutter/material.dart';

class Instructors extends ChangeNotifier {
  final String id;
  final String name;

  Instructors({
    required this.id,
    required this.name,
  });
}

