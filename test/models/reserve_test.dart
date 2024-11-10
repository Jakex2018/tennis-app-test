import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Instructors Model Tests', () {
    test('Constructor Test', testReserveConstructor);
    test('toMap Test', testToMapConstructor);
  });
}

void testReserveConstructor() {
  var court = Reserve(
    comment: 'Comentario',
    reserveId: '1',
    userId: '1',
    courtId: '1',
    instructorId: '1',
    dateReserve: DateTime.now(),
    hourStart: DateTime.now(),
    hourEnd: DateTime.now(),
    dateCreate: DateTime.now(),
  );
  expect(court.comment, 'Comentario');
  expect(court.reserveId, '1');
  expect(court.userId, '1');
  expect(court.courtId, '1');
  expect(court.instructorId, '1');
  expect(court.dateReserve, DateTime.now());
  expect(court.hourStart, DateTime.now());
  expect(court.hourEnd, DateTime.now());
  expect(court.dateCreate, DateTime.now());
}

void testToMapConstructor() {
  var reserve = Reserve(
    comment: 'Comentario',
    reserveId: '1',
    userId: '1',
    courtId: '1',
    instructorId: '1',
    dateReserve: DateTime.now(),
    hourStart: DateTime.now(),
    hourEnd: DateTime.now(),
    dateCreate: DateTime.now(),
  );
  var map = reserve.toMap();

  expect(map['comment'], 'Comentario');
  expect(map['reserveId'], '1');
  expect(map['userId'], '1');
  expect(map['courtId'], '1');
  expect(map['instructorId'], '1');
  expect(map['dateReserve'], DateTime.now());
  expect(map['hourStart'], DateTime.now());
  expect(map['hourEnd'], DateTime.now());
  expect(map['dateCreate'], DateTime.now());
}
