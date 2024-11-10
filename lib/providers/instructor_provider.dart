import 'package:com.tennis.arshh/model/instructors.dart';
import 'package:flutter/material.dart';
class InstructorProvider extends ChangeNotifier {
  final List<Instructors> menu = [
    Instructors(
      id: '1',
      name: 'David Perez',
    ),
    Instructors(
      id: '2',
      name: 'Manuel Rojas',
    ),
    Instructors(
      id: '3',
      name: 'Lisa Rodriguez',
    ),
  ];

  Instructors? _selectedInstructor;

  Instructors? get selectedInstructor => _selectedInstructor;

  void setSelectedInstructor(Instructors? newInstructor) {
    _selectedInstructor = newInstructor;
    notifyListeners();
  }

  void clearReserve() {
    _selectedInstructor = null;
    notifyListeners();
  }
}
