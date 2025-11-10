import 'package:http/http.dart' as http;
import 'dart:convert';
import '../scerets.dart';

class WeatherService {
  Future<Map<String, dynamic>?> fetchWeather() async {
    const cityName = 'Lahore';
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName,pk&appid=$openWeatherApiKey&units=metric',
    );

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
