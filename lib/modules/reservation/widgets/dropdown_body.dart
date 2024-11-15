import 'package:com.tennis.arshh/model/instructors.dart';
import 'package:com.tennis.arshh/providers/instructor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownBody<T> extends StatefulWidget {
  const DropdownBody(
      {super.key,
      required this.width,
      required this.height,
      this.title,
      required this.provider,
      this.availableHours,
      this.availableDates});

  final double width;
  final double height;
  final String? title;
  final T provider;
  final List<String>? availableHours;
  final List<String>? availableDates;

  @override
  State<DropdownBody> createState() => _DropdownBodyState<T>();
}

class _DropdownBodyState<T> extends State<DropdownBody<T>> {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, provider, child) {
      if (provider is InstructorProvider) {
        final instructor = provider;
        String dynamicTitle =
            instructor.selectedInstructor?.name ?? 'Agregar Instructor';

        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<Instructors?>(
              value: instructor.selectedInstructor,
              hint: Text(
                dynamicTitle,
                style: const TextStyle(fontSize: 12),
              ),
              onChanged: (Instructors? newValue) {
                instructor.setSelectedInstructor(newValue);
              },
              items: instructor.menu
                  .map<String>((Instructors instructor) => instructor.name)
                  .map<DropdownMenuItem<Instructors>>((String value) {
                return DropdownMenuItem<Instructors>(
                  value: instructor.menu
                      .firstWhere((element) => element.name == value),
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }

      return Container();
    });
  }
}

