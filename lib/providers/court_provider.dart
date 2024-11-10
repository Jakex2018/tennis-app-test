import 'package:com.tennis.arshh/model/courts.dart';
import 'package:flutter/material.dart';

class CourtsProvider extends ChangeNotifier {
   String? _selectedCourtStart;
  String? _selectedCourtEnd;
  DateTime? _selectedCourtDate;

  String? get selectedCourtStart => _selectedCourtStart;
  String? get selectedCourtEnd => _selectedCourtEnd;
  DateTime? get selectedCourtDate => _selectedCourtDate;

  Courts? _selectedCourt;
  Courts? get selectedCourt => _selectedCourt;
  List<Courts> menuList = [];
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
        latitude: 6.2697324,
        longitude: -75.6025597,
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
        timePlay: '7:00am a 8:00pm',
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
        latitude: 8.0219748,
        longitude: -72.0205763,
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
        timePlay: '7:00 am a 8:00pm',
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
        latitude: 8.0219748,
        longitude: -72.0205763,
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
        timePlay: '7:00 am a 7:00pm',
        date: '9 de julio 2024',
        image: 'public/asset/images/courts03.png',
        isAvailable: true,
        direction: 'Via Av. Caracas y Av.Caroni',
      ),
    );
  }

 
  final Map<String, List<String>> _reservedHours = {};

  bool _isAvailable = true;

  bool get isAvailable => _isAvailable;

  void releaseReservedHour(String courtId, String hour) {
    final court = menu.firstWhere((court) => court.id == courtId);

    final hourIndex = court.allHours.indexOf(hour);
    if (hourIndex != -1) {
      court.isAvailableForHour[hourIndex] = true;
      notifyListeners();
    }
  }

  void toggleAvailability() {
    _isAvailable = !_isAvailable;
    notifyListeners();
  }

  

  void setSelectedCourt(Courts court) {
    _selectedCourt = court;
    notifyListeners();
  }

  

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

  Map<String, dynamic> getCourtDetailsById(String courtId) {
    try {
      final court = menu.firstWhere((court) => court.id == courtId);
      return {
        'id': court.id,
        'name': court.name,
        'image': court.image,
        'typeCourt': court.typeCourt,
        'price': court.price,
        'minimumDuration': court.minimumDuration,
        'latitude': court.latitude,
        'longitude': court.longitude,
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

  void reserveHour(String courtId, String hour, DateTime reserveDate) {
    final court = menu.firstWhere((court) => court.id == courtId);

    final hourIndex = court.allHours.indexOf(hour);
    if (hourIndex != -1) {
      court.isAvailableForHour[hourIndex] = false;

      _reservedHours.putIfAbsent(courtId, () => []).add(hour);
      notifyListeners();
    }
  }

  List<String> getFilteredHours(String courtId) {
    final court = menu.firstWhere(
      (court) => court.id == courtId,
      orElse: () => Courts(
          timePlay: '',
          latitude: 0,
          longitude: 0,
          allHours: [],
          id: '',
          isAvailableForHour: [],
          direction: '',
          price: 0,
          minimumDuration: 0,
          typeCourt: '',
          date: '',
          name: '',
          image: ''),
    );

    return court.allHours.where((hour) {
      return court.isAvailableForHour[court.allHours.indexOf(hour)];
    }).toList();
  }
}
