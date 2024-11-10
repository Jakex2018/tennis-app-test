import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:com.tennis.arshh/model/reserve.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReserveProvider extends ChangeNotifier {
  String _userId = '';
  String _courtId = '';
  String? _instructorId = '';
  DateTime? _reserveDate;
  String? _startTime;
  String? _endTime;
  String _comment = '';
  final TextEditingController commentController = TextEditingController();

  final Map<String, Set<String>> _reservedHours = {};
  final List<Map<String, dynamic>> _reserves = [];
  final Map<String, List<String>> userfavorites = {};

  String get userId => _userId;
  String get courtId => _courtId;
  String? get instructorId => _instructorId;
  DateTime? get reserveDate => _reserveDate;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String get comment => _comment;
  List<Map<String, dynamic>> get reserves => _reserves;

  Map<String, List<String>> reservedHours = {};
  final List<Reserve> _reservations = [];
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  List<Reserve> getReservationsForDate(String courtId, DateTime date) {
    return _reservations.where((reservation) {
      return reservation.courtId == courtId &&
          reservation.hourStart.year == date.year &&
          reservation.hourStart.month == date.month &&
          reservation.hourStart.day == date.day;
    }).toList();
  }

  bool isAvailableForHour(String courtId, String hour, DateTime reserveDate) {
    return !reservedHours.containsKey(courtId) ||
        !reservedHours[courtId]!.contains(hour);
  }

  void reserveHour(String courtId, String hour, DateTime reserveDate) {
    if (isAvailableForHour(courtId, hour, reserveDate)) {
      reservedHours.putIfAbsent(courtId, () => []).add(hour);
      notifyListeners();
    }
  }

  void cancelReservation(String courtId, String hour) {
    if (reservedHours.containsKey(courtId)) {
      reservedHours[courtId]!.remove(hour);
      notifyListeners();
    }
  }

  List<String> getReservedHours(String courtId) {
    return reservedHours[courtId] ?? [];
  }

  void setStartTime(String value) {
    _startTime = value;
    notifyListeners();
  }

  void setEndTime(String value) {
    _endTime = value;
    notifyListeners();
  }

  void setDateTime(DateTime value) {
    _reserveDate = value;
    notifyListeners();
  }

  DateTime convertToDateTime(String hour) {
    final now = DateTime.now();
    try {
      if (hour.contains('AM') || hour.contains('PM')) {
        final parsedTime = DateFormat('hh:mm a').parse(hour);
        return DateTime(
            now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
      } else {
        final timePart = hour.split(':');
        return DateTime(now.year, now.month, now.day, int.parse(timePart[0]),
            int.parse(timePart[1]));
      }
    } catch (e) {
      throw FormatException('Invalid time format: $hour');
    }
  }

  Future<bool> addReserves(String courtId, DateTime date) async {
    final dateReserve = DateTime(date.year, date.month, date.day);
    final reservesDay = _reserves.where((reserve) {
      return reserve['courtId'] == courtId &&
          reserve['date'].isAtSameMomentAs(dateReserve);
    }).toList();

    if (reservesDay.length == 3) {
      return false;
    }

    _reserves.add({
      'courtId': courtId,
      'date': date,
    });
    notifyListeners();
    return true;
  }

  Future<void> cancelReserveAndReleaseHours(
      String courtId, DateTime date) async {
    _reserves.removeWhere((reserva) =>
        reserva['courtId'] == courtId &&
        reserva['date'].isAtSameMomentAs(date));

    for (var reserva in _reserves) {
      if (reserva['courtId'] == courtId &&
          reserva['date'].isAtSameMomentAs(date)) {
        releaseReservedHour(courtId, reserva['startTime']);
        releaseReservedHour(courtId, reserva['endTime']);
      }
    }

    notifyListeners();
  }

  void releaseReservedHour(String courtId, String hour) {
    // Si la cancha tiene horas reservadas
    if (_reservedHours.containsKey(courtId)) {
      _reservedHours[courtId]?.remove(hour);
      notifyListeners();
    }
  }

  void setReserveDetails(String userId, String courtId, DateTime date,
      String instructorId, String startTime, String endTime, String comment) {
    _userId = userId;
    _courtId = courtId;
    _instructorId = instructorId;
    _reserveDate = date;
    _startTime = startTime;
    _endTime = endTime;
    _comment = comment;
    notifyListeners();
  }

  Future<void> saveReserve() async {
    try {
      final reserve =
          FirebaseFirestore.instance.collection('reservations').doc();

      final reserveDoc = Reserve(
        instructorId: _instructorId!,
        reserveId: reserve.id,
        userId: _userId,
        courtId: _courtId,
        dateReserve: _reserveDate!,
        hourEnd: convertToDateTime(_endTime!),
        hourStart: convertToDateTime(_startTime!),
        dateCreate: DateTime.now(),
        comment: _comment,
      );

      await reserve.set(reserveDoc.toMap());

      reserveHour(_courtId, _startTime!, _reserveDate!);
      reserveHour(_courtId, _endTime!, _reserveDate!);

      notifyListeners();
    } catch (e) {
      return;
    }
  }

  void clearReserve() {
    _reserveDate = null;
    _startTime = null;
    _instructorId = null;
    _endTime = null;
    _comment = '';
    commentController.clear();
    notifyListeners();
  }

  Map<String, dynamic> getCourtNameById(String courtId, List<Courts> courts) {
    try {
      final court = courts.firstWhere((court) => court.id == courtId);
      return {
        'name': court.name,
        'image': court.image,
        'typeCourt': court.typeCourt,
        'price': court.price,
        'minimumDuration': court.minimumDuration,
      };
    } catch (e) {
      return {
        'name': 'Cancha desconocida',
        'image': '',
        'typeCourt': '',
        'price': 0,
        'minimumDuration': 0,
        'direction': '',
        'availableDates': []
      };
    }
  }

  Future<void> getReservesUser(String userId, List<Courts> courts) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .get();

      final List<Map<String, dynamic>> userReserves =
          query.docs.map((doc) => doc.data()).toList();

      List<Future<void>> nameFetches = [];

      for (var reserve in userReserves) {
        final courtName = getCourtNameById(reserve['courtId'], courts);
        reserve['courtName'] = courtName;

        nameFetches.add(
          getUserNameFromFirestore(reserve['userId']).then((userName) {
            reserve['userName'] = userName;
          }),
        );

        final dateString = reserve['dateReserve'] is String
            ? reserve['dateReserve'] as String
            : (reserve['dateReserve'] as DateTime).toString();

        reserve['formattedDate'] = formatDate(DateTime.parse(dateString));
      }

      await Future.wait(nameFetches);

      _reserves.clear();
      _reserves.addAll(userReserves);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<String> getUserNameFromFirestore(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return doc.data()?['name'] ?? 'Usuario desconocido';
      } else {
        return 'Usuario desconocido';
      }
    } catch (e) {
      return 'Usuario desconocido';
    }
  }

  List<String> getFavorites(String userId) {
    return userfavorites[userId] ?? [];
  }

  void addToFavorites(String userId, String reserveId) async {
    if (!userfavorites.containsKey(userId)) {
      userfavorites[userId] = [];
    }
    if (!userfavorites[userId]!.contains(reserveId)) {
      userfavorites[userId]!.add(reserveId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites_$userId', userfavorites[userId]!);
    await saveFavoritesToPrefs(userId);
    notifyListeners();
  }

  void removeFromFavorites(String userId, String reserveId) async {
    if (userfavorites.containsKey(userId)) {
      userfavorites[userId]!.remove(reserveId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites_$userId', userfavorites[userId]!);
    await saveFavoritesToPrefs(userId);
    notifyListeners();
  }

  bool isFavorite(String userId, String reserveId) {
    return userfavorites.containsKey(userId) &&
        userfavorites[userId]!.contains(reserveId);
  }

  Future<void> loadFavoritesFromPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorites_$userId');
    userfavorites[userId] = favoriteList ?? [];
    notifyListeners();
  }

  Future<void> saveFavoritesToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = userfavorites[userId] ?? [];
    await prefs.setStringList('favorites_$userId', favorites);
  }
}
