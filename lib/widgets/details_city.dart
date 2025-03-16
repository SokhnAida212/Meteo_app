import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/city_model.dart';
import '../utils/constantes.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailsCity extends StatelessWidget {
  final WeatherData weatherData;

  const DetailsCity({super.key, required this.weatherData});

  String getTodayDate() {
    initializeDateFormatting('fr', null);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE d MMMM', 'fr').format(now).toUpperCase();
    return formattedDate;
  }
  String getCityTime(int timezoneOffset) {
    DateTime now = DateTime.now().toUtc();
    DateTime cityTime = now.add(Duration(seconds: timezoneOffset));
    String formattedTime = DateFormat('HH:mm').format(cityTime);
    return formattedTime;
  }
  void _launchMaps(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Constantes myConst = Constantes();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            weatherData.cityName,
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            getTodayDate(),
                            style: const TextStyle(fontSize: 16, color: Colors.white70),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _launchMaps(weatherData.latitude, weatherData.longitude),
                  child: Text('Voir sur Google Maps'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData getWeatherIcon(String weatherDescription) {
    switch (weatherDescription.toLowerCase()) {
      case 'clear sky':
        return Icons.wb_sunny;
      case 'few clouds':
      case 'scattered clouds':
      case 'broken clouds':
        return Icons.cloud;
      case 'shower rain':
      case 'rain':
        return Icons.beach_access;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.cloud;
    }
  }
}
