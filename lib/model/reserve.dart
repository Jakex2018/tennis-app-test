import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reserve {
  final String reserveId;
  final String userId;
  final String courtId;
  final String instructorId;
  final String comment;
  final DateTime dateReserve;
  final DateTime hourStart;
  final DateTime hourEnd;
  final DateTime dateCreate;

  Reserve({
    required this.instructorId,
    required this.comment,
    required this.reserveId,
    required this.dateReserve,
    required this.hourEnd,
    required this.dateCreate,
    required this.userId,
    required this.courtId,
    required this.hourStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'instructorId': instructorId,
      'reserveId': reserveId,
      'userId': userId,
      'courtId': courtId,
      'dateReserve': Timestamp.fromDate(dateReserve),
      'hourStart': Timestamp.fromDate(hourStart),
      'hourEnd': Timestamp.fromDate(hourEnd),
      'dateCreate': Timestamp.fromDate(dateCreate),
      'comment': comment,
    };
  }

  factory Reserve.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reserve(
      instructorId: data['instructorId'],
      reserveId: doc.id,
      userId: data['userId'],
      courtId: data['courtId'],
      comment: data['comment'],
      dateReserve: (data['dateReserve'] as Timestamp).toDate(),
      hourStart: (data['hourStart'] as Timestamp).toDate(),
      hourEnd: (data['hourEnd'] as Timestamp).toDate(),
      dateCreate: (data['dateCreate'] as Timestamp).toDate(),
    );
  }
}

class ReserveProvider extends ChangeNotifier {
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _userId = '';
  String get userId => _userId;

  String _courtId = '';
  String get courtId => _courtId;

  String? _instructorId = '';
  String? get instructorId => _instructorId;

  DateTime? _reserveDate;
  DateTime? get reserveDate => _reserveDate;

  String? _startTime;
  String? get startTime => _startTime;

  String? _endTime;
  String? get endTime => _endTime;

  String _comment = '';
  String get comment => _comment;

  final TextEditingController commentController = TextEditingController();

  final List<Map<String, dynamic>> _reserves = [];
  List<Map<String, dynamic>> get reserves => _reserves;

  void setUserId() {
    // Suponiendo que estás usando Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid; // Asigna el userId
      notifyListeners(); // Notifica a los listeners de que el valor ha cambiado
    }
  }

  Future<bool> addReserves(String courtId, DateTime date) async {
    final dateReserve = DateTime(date.year, date.month, date.day);
    final reservesDay = _reserves.where((reserve) {
      return reserve['courtId'] == courtId &&
          reserve['date'].isAtSameMomentAs(dateReserve);
    }).toList();

    if (reservesDay.length >= 3) {
      return false;
    }
    _reserves.add({
      'courtId': courtId,
      'date': date,
    });

    notifyListeners();
    return true;
  }

  Future<void> cancelarReserva(String courtId, DateTime date) async {
    _reserves.removeWhere((reserva) =>
        reserva['courtId'] == courtId &&
        reserva['date'].isAtSameMomentAs(date));
    notifyListeners();
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

  String get commentText => commentController.text;

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

      @override
      void dispose() {
        commentController.dispose(); // No olvides liberar el controlador
        super.dispose();
      }

      await reserve.set(
        reserveDoc.toMap(),
      );
    } catch (e) {
      return;
    }
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

  void clearReserve() {
    _reserveDate = null;
    _startTime = null;
    _instructorId = null;
    _endTime = null;
    _comment = '';
    commentController.clear();
  }

  // Método para obtener el nombre de la cancha
  Map<String, dynamic> getCourtNameById(String courtId, List<Courts> courts) {
    try {
      final court = courts.firstWhere((court) => court.id == courtId);
      return {
        'name': court.name,
        'image': court.image,
        'typeCourt': court.typeCourt,
        'temp': court.temp,
        'price': court.price,
        'minimumDuration': court.minimumDuration,
      };
    } catch (e) {
      return {
        'name': 'Cancha desconocida',
        'image': '',
        'typeCourt': '',
        'temp': 0,
        'price': 0,
        'minimumDuration': 0,
        'direction': '',
        'availableDates': []
      };
    }
  }

  //BUSCAR RESERVA DEL USER

  Future<void> getReservesUser(String userId, List<Courts> courts) async {
    try {
      // Buscar las reservas del usuario
      final query = await FirebaseFirestore.instance
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .get();

      final List<Map<String, dynamic>> userReserves =
          query.docs.map((doc) => doc.data()).toList();

      // Crear una lista de Futures para obtener los nombres de los usuarios
      List<Future<void>> nameFetches = [];

      // Añadir el nombre de la cancha y el nombre del usuario a cada reserva
      for (var reserve in userReserves) {
        final courtName = getCourtNameById(reserve['courtId'], courts);
        reserve['courtName'] = courtName;

        // Obtener el nombre del usuario
        nameFetches.add(
          getUserNameFromFirestore(reserve['userId']).then((userName) {
            reserve['userName'] = userName; // Asignar el nombre al reserve
          }),
        );

        // Procesar la fecha y formatearla
        if (reserve['dateReserve'] is String) {
          final dateString = reserve['dateReserve'] as String;
          final dateReserve = DateTime.parse(dateString);
          reserve['formattedDate'] = formatDate(dateReserve);
        } else if (reserve['dateReserve'] is DateTime) {
          final dateReserve = reserve['dateReserve'] as DateTime;
          reserve['formattedDate'] = formatDate(dateReserve);
        } else {
          reserve['formattedDate'] = 'Fecha desconocida';
          print('Error: dateReserve no es un String ni un DateTime');
        }
      }

      // Esperar a que todos los nombres se obtengan
      await Future.wait(nameFetches);

      // Actualizar la lista de reservas en el provider
      _reserves.clear();
      _reserves.addAll(userReserves);
      notifyListeners();
    } catch (e) {
      print('Error al obtener las reservas: $e');
      return;
    }
  }

  String? getUserName(String userId) {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? 'Usuario desconocido';
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
      print('Error al obtener el nombre del usuario: $e');
      return 'Usuario desconocido';
    }
  }

  //LISTA DE FAVORITOS DEL USUARIO
  final Map<String, List<String>> userfavorites = {};
  List<String> getFavorites(String userId) {
    return userfavorites[userId] ?? [];
  }

  //AGREGAR RESERVA A FAVORITOS
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

  //ELIMINAR RESERVA DE FAVORITOS
  void removeFromFavorites(String userId, String reserveId) async {
    if (userfavorites.containsKey(userId)) {
      userfavorites[userId]!.remove(reserveId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites_$userId', userfavorites[userId]!);
    await saveFavoritesToPrefs(userId);
    notifyListeners();
  }

  //VERIFICAR SI LA RESERVA ESTA EN EL FAVORITOS
  bool isFavorite(String userId, String reserveId) {
    return userfavorites.containsKey(userId) &&
        userfavorites[userId]!.contains(reserveId);
  }

  //RETENER LAS RESERVAS FAVORITAS DEL USUARIO
  Future<void> loadFavoritesFromPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar los favoritos desde SharedPreferences
    final favoriteList = prefs.getStringList('favorites_$userId');

    if (favoriteList != null) {
      // Actualizar los favoritos en el provider
      userfavorites[userId] = favoriteList;
    } else {
      userfavorites[userId] = [];
    }

    notifyListeners();
  }

  //GUARDAR LAS RESERVAS FAVORITAS DEL USUARIO EN SHAREDPREFERENCES
  Future<void> saveFavoritesToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = userfavorites[userId] ?? [];

    // Guardar los favoritos como una lista de cadenas en SharedPreferences
    await prefs.setStringList('favorites_$userId', favorites);
  }
}




/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.tennis.arshh/model/courts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reserve {
  final String reserveId;
  final String userId;
  final String courtId;
  final String instructorId;
  final String comment;
  final DateTime dateReserve;
  final DateTime hourStart;
  final DateTime hourEnd;
  final DateTime dateCreate;

  Reserve({
    required this.instructorId,
    required this.comment,
    required this.reserveId,
    required this.dateReserve,
    required this.hourEnd,
    required this.dateCreate,
    required this.userId,
    required this.courtId,
    required this.hourStart,
  });

  Map<String, dynamic> toMap() {
    return {
      'instructorId': instructorId,
      'reserveId': reserveId,
      'userId': userId,
      'courtId': courtId,
      'dateReserve': Timestamp.fromDate(dateReserve),
      'hourStart': Timestamp.fromDate(hourStart),
      'hourEnd': Timestamp.fromDate(hourEnd),
      'dateCreate': Timestamp.fromDate(dateCreate),
      'comment': comment,
    };
  }

  factory Reserve.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reserve(
      instructorId: data['instructorId'],
      reserveId: doc.id,
      userId: data['userId'],
      courtId: data['courtId'],
      comment: data['comment'],
      dateReserve: (data['dateReserve'] as Timestamp).toDate(),
      hourStart: (data['hourStart'] as Timestamp).toDate(),
      hourEnd: (data['hourEnd'] as Timestamp).toDate(),
      dateCreate: (data['dateCreate'] as Timestamp).toDate(),
    );
  }
}

class ReserveProvider extends ChangeNotifier {
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _userId = '';
  String get userId => _userId;

  String _courtId = '';
  String get courtId => _courtId;

  String? _instructorId = '';
  String? get instructorId => _instructorId;

  DateTime? _reserveDate;
  DateTime? get reserveDate => _reserveDate;

  String? _startTime;
  String? get startTime => _startTime;

  String? _endTime;
  String? get endTime => _endTime;

  String _comment = '';
  String get comment => _comment;

  final TextEditingController commentController = TextEditingController();

  final List<Map<String, dynamic>> _reserves = [];
  List<Map<String, dynamic>> get reserves => _reserves;

  void setUserId() {
    // Suponiendo que estás usando Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid; // Asigna el userId
      notifyListeners(); // Notifica a los listeners de que el valor ha cambiado
    }
  }

  Future<bool> addReserves(String courtId, DateTime date) async {
    final dateReserve = DateTime(date.year, date.month, date.day);
    final reservesDay = _reserves.where((reserve) {
      return reserve['courtId'] == courtId &&
          reserve['date'].isAtSameMomentAs(dateReserve);
    }).toList();

    if (reservesDay.length >= 3) {
      return false;
    }
    _reserves.add({
      'courtId': courtId,
      'date': date,
    });

    notifyListeners();
    return true;
  }

  Future<void> cancelarReserva(String courtId, DateTime date) async {
    _reserves.removeWhere((reserva) =>
        reserva['courtId'] == courtId &&
        reserva['date'].isAtSameMomentAs(date));
    notifyListeners();
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

  String get commentText => commentController.text;

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

      @override
      void dispose() {
        commentController.dispose(); // No olvides liberar el controlador
        super.dispose();
      }

      await reserve.set(
        reserveDoc.toMap(),
      );
    } catch (e) {
      return;
    }
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

  void clearReserve() {
    _reserveDate = null;
    _startTime = null;
    _instructorId = null;
    _endTime = null;
    _comment = '';
    commentController.clear();
  }

  // Método para obtener el nombre de la cancha
  Map<String, dynamic> getCourtNameById(String courtId, List<Courts> courts) {
    try {
      final court = courts.firstWhere((court) => court.id == courtId);
      return {
        'name': court.name,
        'image': court.image,
        'typeCourt': court.typeCourt,
        'temp': court.temp,
        'price': court.price,
        'minimumDuration': court.minimumDuration,
      };
    } catch (e) {
      return {
        'name': 'Cancha desconocida',
        'image': '',
        'typeCourt': '',
        'temp': 0,
        'price': 0,
        'minimumDuration': 0,
        'direction': '',
        'availableDates': []
      };
    }
  }

  //BUSCAR RESERVA DEL USER
  Future<void> getReservesUser(String userId, List<Courts> courts) async {
    try {
      //BUSCAR DATOS
      final query = await FirebaseFirestore.instance
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .get();
      //AGREGARLOS A LA LISTA
      final List<Map<String, dynamic>> userReserves =
          query.docs.map((doc) => doc.data()).toList();

      // Añadir el nombre de la cancha a cada reserva
      for (var reserve in userReserves) {
        final courtName = getCourtNameById(reserve['courtId'], courts);
        reserve['courtName'] = courtName;
        // Aquí añades el nombre del usuario
        final userName = await getUserNameFromFirestore(reserve['userId']);
        reserve['userName'] = userName;

        if (reserve['dateReserve'] is String) {
          final dateString = reserve['dateReserve'] as String;
          final dateReserve =
              DateTime.parse(dateString); // Convertir el String a DateTime
          reserve['formattedDate'] =
              formatDate(dateReserve); // Formatear la fecha
        } else if (reserve['dateReserve'] is DateTime) {
          final dateReserve = reserve['dateReserve'] as DateTime;
          reserve['formattedDate'] = formatDate(dateReserve);
        } else {
          reserve['formattedDate'] = 'Fecha desconocida';
          print('Error: dateReserve no es un String ni un DateTime');
        }
      }

      _reserves.clear();
      _reserves.addAll(userReserves);
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  String? getUserName(String userId) {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? 'Usuario desconocido';
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
      print('Error al obtener el nombre del usuario: $e');
      return 'Usuario desconocido';
    }
  }
}




 */









