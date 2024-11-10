import 'package:com.tennis.arshh/model/instructors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Instructors Model Tests', () {
    test('Constructor Test', testInstructorsConstructor);
  });
}

void testInstructorsConstructor() {
  var court = Instructors(
    id: '1',
    name: 'Pedro Perez',
  );
  expect(court.id, '1');
  expect(court.name, 'Pedro Perez');
}
