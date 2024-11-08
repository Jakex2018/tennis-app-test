import 'package:flutter/material.dart';

class Courts extends ChangeNotifier {
  final String id;
  final String name;
  final String timePlay;
  final String typeCourt;
  final String date;
  final int temp;
  final String image;
  final int price;
  final int minimumDuration;
  final String direction;
  final bool isAvailable;
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
      required this.allHours,
      required this.id,
      required this.isAvailableForHour,
      this.isAvailable = true,
      required this.direction,
      required this.price,
      required this.minimumDuration,
      required this.typeCourt,
      required this.date,
      required this.temp,
      required this.name,
      required this.image});
}

class CourtsProvider extends ChangeNotifier {
  final List<Courts> menu;

  CourtsProvider() : menu = [] {
    _initializeCourts();
  }

  void _initializeCourts() {
    menu.add(
      Courts(
        id: '0',
        name: 'Epic Box',
        price: 50,
        allHours: [
          '7:00 AM',
          '8:00 AM',
          '9:00 AM',
          '10:00 AM',
          '11:00 AM',
          '12:00 PM',
          '13:00 PM',
          '14:00 PM',
          '15:00 PM',
          '16:00 PM',
          '17:00 PM',
          '18:00 PM',
          '19:00 PM',
          '20:00 PM',
        ],
        isAvailableForHour: List.generate(15, (_) => true),
        minimumDuration: 1,
        typeCourt: 'Cancha tipo A',
        timePlay: '8:00am a 8:00pm',
        temp: 30,
        date: '9 de julio 2024',
        image: 'public/asset/images/courts01.png',
        isAvailable: true,
        direction: 'Via Av. Caracas y Av.Caroni',
      ),
    );
    menu.add(
      Courts(
        id: '1',
        name: 'Sport Box',
        price: 30,
        allHours: [
          '7:00 AM',
          '8:00 AM',
          '9:00 AM',
          '10:00 AM',
          '11:00 AM',
          '12:00 PM',
          '13:00 PM',
          '14:00 PM',
          '15:00 PM',
          '16:00 PM',
          '17:00 PM',
          '18:00 PM',
          '19:00 PM',
          '20:00 PM',
        ],
        isAvailableForHour: List.generate(15, (_) => true),
        minimumDuration: 1,
        typeCourt: 'Cancha tipo C',
        timePlay: '8:00 am a 8:00pm',
        temp: 30,
        date: '9 de julio 2024',
        image: 'public/asset/images/courts02.png',
        isAvailable: false,
        direction: 'Via Av. Caracas y Av.Caroni',
      ),
    );
    menu.add(
      Courts(
        id: '3',
        name: 'Cancha multiple',
        allHours: [
          '7:00 AM',
          '8:00 AM',
          '9:00 AM',
          '10:00 AM',
          '11:00 AM',
          '12:00 PM',
          '13:00 PM',
          '14:00 PM',
          '15:00 PM',
          '16:00 PM',
          '17:00 PM',
          '18:00 PM',
          '19:00 PM',
          '20:00 PM',
        ],
        price: 20,
        isAvailableForHour: List.generate(15, (_) => true),
        minimumDuration: 1,
        typeCourt: 'Cancha tipo C',
        timePlay: '8:00 am a 8:00pm',
        temp: 30,
        date: '9 de julio 2024',
        image: 'public/asset/images/courts03.png',
        isAvailable: true,
        direction: 'Via Av. Caracas y Av.Caroni',
      ),
    );
  }

  String? _selectedCourtStart;
  String? _selectedCourtEnd;
  DateTime? _selectedCourtDate;

  bool _isAvailable = true;

  bool get isAvailable => _isAvailable;

  void toggleAvailability() {
    _isAvailable = !_isAvailable;
    notifyListeners();
  }

  String? get selectedCourtStart => _selectedCourtStart;
  String? get selectedCourtEnd => _selectedCourtEnd;
  DateTime? get selectedCourtDate => _selectedCourtDate;

  Courts? _selectedCourt;
  Courts? get selectedCourt => _selectedCourt;

  void setSelectedCourt(Courts court) {
    _selectedCourt = court;
    notifyListeners();
  }

  String? get selectedCourtId => _selectedCourt?.id;

  //FECHAS
  List<DateTime> get availableDates =>
      menu.isNotEmpty ? menu[0].availableDates : [];

  List<DateTime> getFilteredDates(String courtName) {
    try {
      final court = menu.firstWhere((court) => court.name == courtName);
      return court.availableDates;
    } catch (e) {
      return [];
    }
  }

  List<Courts> menuList = []; // Aquí se guarda la lista de canchas

  Map<String, dynamic> getCourtDetailsById(String courtId) {
    try {
      final court = menu.firstWhere((court) => court.id == courtId);
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

// Este método se llamará cuando el usuario reserve una hora
  void reserveHour(String courtId, String hour) {
    final court = menu.firstWhere((court) => court.id == courtId);

    // Encuentra la hora seleccionada y marca como no disponible
    final hourIndex = court.allHours.indexOf(hour);
    if (hourIndex != -1) {
      // Marcar la hora como ocupada
      court.isAvailableForHour[hourIndex] = false;
      notifyListeners();
    }
  }

  // Este método devuelve las horas disponibles para una cancha específica
  List<String> getFilteredHours(String courtId) {
    try {
      final court = menu.firstWhere((court) => court.id == courtId);

      List<String> availableHours = [];
      for (int i = 0; i < court.allHours.length; i++) {
        if (court.isAvailableForHour[i]) {
          availableHours.add(court.allHours[i]);
        }
      }
      return availableHours;
    } catch (e) {
      return [];
    }
  }
}
