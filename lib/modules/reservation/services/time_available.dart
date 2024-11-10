import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:com.tennis.arshh/modules/reservation/providers/reserve_provider.dart';

import 'package:intl/intl.dart';

class TimeAvailable {
  Future<bool> areTimesAvailable(ReserveProvider reserverProvider,
      String courtId, String startTime, String endTime, DateTime date) async {
    final List<Reserve> existingReservations =
        reserverProvider.getReservationsForDate(courtId, date);

    DateTime startDateTime = _convertToDateTime(startTime, date);
    DateTime endDateTime = _convertToDateTime(endTime, date);

    for (var reservation in existingReservations) {
      DateTime existingStartTime = reservation.hourStart;
      DateTime existingEndTime = reservation.hourEnd;

      if ((startDateTime.isBefore(existingEndTime) &&
              startDateTime.isAfter(existingStartTime)) ||
          (endDateTime.isBefore(existingEndTime) &&
              endDateTime.isAfter(existingStartTime))) {
        return false; 
      }
    }

    return true; 
  }

  DateTime _convertToDateTime(String hour, DateTime date) {
    final parsedTime = DateFormat('h:mm a').parse(hour);
    return DateTime(
        date.year, date.month, date.day, parsedTime.hour, parsedTime.minute);
  }
}
