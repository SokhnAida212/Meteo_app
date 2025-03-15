import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/city_model.dart';
import '../models/theme_provider.dart';
import '../screens/home_screen.dart';
import '../utils/constantes.dart';
import 'package:intl/date_symbol_data_local.dart';

class WeatherDetails extends StatelessWidget {
  final WeatherData weatherData;

  WeatherDetails({super.key, required this.weatherData});

  String getTodayDate() {
    initializeDateFormatting('fr', null);
    DateTime now = DateTime.now();
    String formattedDate =
    DateFormat('EEEE d MMMM', 'fr').format(now).toUpperCase();
    return formattedDate;
  }

  // Fonction pour ouvrir Google Maps avec les coordonnées de la ville
  void openGoogleMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${weatherData.latitude},${weatherData.longitude}";
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Impossible d’ouvrir Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Constantes myConst = Constantes();
    IconData weatherIcon = getWeatherIcon(weatherData.weatherDescription);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    'assets/bouton-fleche.png',
                    width: 30,
                    height: 30,color: themeProvider.iconColor
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    'assets/accueil.png',
                    width: 30,
                    height: 30,color: themeProvider.iconColor
                  ),
                ),
              ),
              IconButton(
                icon: Icon(themeProvider.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                    color: themeProvider.iconColor),
                onPressed: () {
                  // Bascule entre le mode clair et sombre
                  themeProvider.toggleTheme(themeProvider.themeMode == ThemeMode.light);
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeProvider.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et date
            Container(
              margin: EdgeInsets.only(left: 140),
              child: Text(
                weatherData.cityName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 120),
              child: Text(
                getTodayDate(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Container affichant l'icône météo et la description
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0x8DBCF6FF),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue,
                    offset: const Offset(0, 20),
                    blurRadius: 10,
                    spreadRadius: -12,
                  )
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    left: 20,
                    child: Icon(
                      weatherIcon,
                      size: 170,
                      color:
                      Colors.grey.shade300.withOpacity(0.8),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 20,
                    right: 20,
                    child: Text(
                      weatherData.weatherDescription,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Text(
                      '${weatherData.temperature}°',
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Color(0x8DBCF6FF),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Première rangée d'icônes
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Vitesse du vent
                  Column(
                    children: [
                      const Text(
                        'Vitesse du Vent',
                        style: TextStyle(
                          color: Color(0xB3D4F5FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E8FB),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.asset('assets/windspeed.png'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weatherData.windSpeed} km/h',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3D4F5FF),
                        ),
                      )
                    ],
                  ),
                  // Humidité
                  Column(
                    children: [
                      const Text(
                        'Humidité',
                        style: TextStyle(
                          color: Color(0xB3D4F5FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E8FB),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.asset('assets/humidity.png'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weatherData.humidity,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3D4F5FF),
                        ),
                      )
                    ],
                  ),
                  // Température max
                  Column(
                    children: [
                      const Text(
                        'Temp_max',
                        style: TextStyle(
                          color: Color(0xB3D4F5FF),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E8FB),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.asset('assets/max-temp.png'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weatherData.temp_max}°',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3D4F5FF),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Deuxième rangée d'icônes
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Précipitations
                  Column(
                    children: [
                      const Text(
                        'Précipitation',
                        style: TextStyle(
                          color: Color(0xB3D4F5FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E8FB),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.asset('assets/pluie.png'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weatherData.precipitation} mm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3D4F5FF),
                        ),
                      )
                    ],
                  ),
                  // Humidité (encore, si besoin d'afficher deux fois)
                  Column(
                    children: [
                      const Text(
                        'Humidité',
                        style: TextStyle(
                          color: Color(0xB3D4F5FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E8FB),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.asset('assets/humidity.png'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weatherData.humidity,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3D4F5FF),
                        ),
                      )
                    ],
                  ),
                  // Température max (répétée si besoin)
                  Column(
                    children: [
                      const Text(
                        'Temp_max',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3D4F5FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xffE0E8FB),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.asset('assets/max-temp.png'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weatherData.temp_max}°',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xB3D4F5FF),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Bouton "Voir sur Google Maps" en bas
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: openGoogleMaps,
                icon: const Icon(Icons.location_on, color: Colors.white),
                label: const Text(
                  "Voir sur Google Maps",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
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
