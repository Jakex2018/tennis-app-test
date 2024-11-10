import 'package:com.tennis.arshh/model/courts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Courts Model Tests', () {
    test('Constructor Test', testCourtsConstructor);
    test('Availability Test', testCourtAvailability);
    test('Available Dates Test', testAvailableDates);
    test('Availability for Hour Test', testAvailabilityForHour);
  });
}

void testCourtsConstructor() {
  var allHours = ['09:00', '10:00', '11:00'];
  var isAvailableForHour = [true, true, false];

  var court = Courts(
    id: '123',
    name: 'Court 1',
    timePlay: '2 hours',
    typeCourt: 'Clay',
    date: '2024-07-09',
    image: 'court_image.jpg',
    price: 50,
    minimumDuration: 1,
    direction: 'Street 123',
    latitude: 19.4326,
    longitude: -99.1332,
    allHours: allHours,
    isAvailableForHour: isAvailableForHour,
  );

  expect(court.id, '123');
  expect(court.name, 'Court 1');
  expect(court.price, 50);
  expect(court.isAvailableForHour, isAvailableForHour);
}

void testCourtAvailability() {
  var allHours = ['09:00', '10:00', '11:00'];
  var isAvailableForHour = [true, true, false];

  var court = Courts(
    id: '123',
    name: 'Court 1',
    timePlay: '2 hours',
    typeCourt: 'Clay',
    date: '2024-07-09',
    image: 'court_image.jpg',
    price: 50,
    minimumDuration: 1,
    direction: 'Street 123',
    latitude: 19.4326,
    longitude: -99.1332,
    allHours: allHours,
    isAvailableForHour: isAvailableForHour,
  );

  expect(court.isAvailable, true);

  var courtUnavailable = Courts(
    id: '124',
    name: 'Court 2',
    timePlay: '1 hour',
    typeCourt: 'Hard',
    date: '2024-07-10',
    image: 'court_image2.jpg',
    price: 40,
    minimumDuration: 1,
    direction: 'Street 124',
    latitude: 19.4326,
    longitude: -99.1332,
    allHours: allHours,
    isAvailableForHour: isAvailableForHour,
    isAvailable: false,
  );

  expect(courtUnavailable.isAvailable, false);
}
void testAvailableDates() {
  var court = Courts(
    id: '123',
    name: 'Court 1',
    timePlay: '2 hours',
    typeCourt: 'Clay',
    date: '2024-07-09',
    image: 'court_image.jpg',
    price: 50,
    minimumDuration: 1,
    direction: 'Street 123',
    latitude: 19.4326,
    longitude: -99.1332,
    allHours: ['09:00', '10:00', '11:00'],
    isAvailableForHour: [true, true, false],
  );

  expect(court.availableDates.length, 5);
  expect(court.availableDates[0], DateTime(2024, 7, 9));
  expect(court.availableDates[1], DateTime(2024, 7, 10));
  expect(court.availableDates[4], DateTime(2024, 7, 13));
}

void testAvailabilityForHour() {
  var allHours = ['09:00', '10:00', '11:00'];
  var isAvailableForHour = [true, true, false];

  var court = Courts(
    id: '123',
    name: 'Court 1',
    timePlay: '2 hours',
    typeCourt: 'Clay',
    date: '2024-07-09',
    image: 'court_image.jpg',
    price: 50,
    minimumDuration: 1,
    direction: 'Street 123',
    latitude: 19.4326,
    longitude: -99.1332,
    allHours: allHours,
    isAvailableForHour: isAvailableForHour,
  );

  expect(court.isAvailableForHour[0], true); 
  expect(court.isAvailableForHour[2], false); 
}
