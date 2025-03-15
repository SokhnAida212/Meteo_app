import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';


class WeatherAPI {
  static Future<WeatherData> fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?appid=a34f0e1e7badb28dbd17247752bf1aea&q=$city&lang=fr&aqi=no'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      double precipitation = data['rain'] != null
          ? data['rain']['1h'].toDouble()
          : 0.0;

      print('Response body: $data');

      return WeatherData(
        cityName: data['name'],
        latitude: data['coord']['lat'],
        longitude: data['coord']['lon'],
        temperature: (data['main']['temp'] - 273.15).toStringAsFixed(0),
        weatherDescription: data['weather'][0]['description'],
        windSpeed: data['wind']['speed'].toString(),
        humidity: data['main']['humidity'].toString(),
        temp_max: (data['main']['temp_max'] - 273.15).toStringAsFixed(0),
        precipitation: precipitation,
        timezone: data['timezone'],
      );
    } else {
      try {
        final response = await http.get(Uri.parse(
            'http://api.openweathermap.org/data/2.5/weather?appid=a34f0e1e7badb28dbd17247752bf1aea&q=$city&lang=fr&aqi=no'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          return WeatherData.fromJson(data);
        } else {
          throw Exception('Erreur ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        throw Exception('Erreur lors de la récupération des données: $e');
      }
    }
  }
}
