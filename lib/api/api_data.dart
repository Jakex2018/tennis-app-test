import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WheaterService {

  static String apiKey = dotenv.env['API_KEY'] ?? '';

  //PREDICCION DE CLIMA
  Future<int> rainProbability(double lat, double lon) async {
    final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey'),
        headers: {
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final rainProbability = data['list'][0]['pop'] ?? 0;

      return (rainProbability * 100).toInt();
    } else {
      throw Exception('Error fetching weather data');
    }
  }
}