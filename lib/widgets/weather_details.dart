import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/city_model.dart';
import '../models/theme_provider.dart';
import '../screens/home_screen.dart';
import '../utils/constantes.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class WeatherDetails extends StatefulWidget {
  final WeatherData weatherData;

  const WeatherDetails({super.key, required this.weatherData});

  @override
  _WeatherDetailsState createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  bool _isDateFormattingInitialized = false;

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



  void openGoogleMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.weatherData.latitude},${widget.weatherData.longitude}";
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
    String weatherImage = _getWeatherImage(widget.weatherData.weatherDescription);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Météo', style: TextStyle(color: themeProvider.textColor)),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: themeProvider.iconColor),
            onSelected: (String result) {
              switch (result) {
                case 'Accueil':
                  Navigator.pop(context);
                  break;
                case 'Changer le thème':
                  themeProvider.toggleTheme(themeProvider.themeMode == ThemeMode.light);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Accueil',
                child: Text('Accueil'),
              ),
              PopupMenuItem<String>(
                value: 'Changer le thème',
                child: Text('Changer le thème'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeProvider.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre et date
              Center(
                child: Container(
                  child: Text(
                    widget.weatherData.cityName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    getTodayDate(),
                    style: TextStyle(
                      color: themeProvider.textColor.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 57),
              // Container affichant l'icône météo et la description
              Container(
                width: size.width,
                height: 200,
                decoration: BoxDecoration(
                  color: themeProvider.cardColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      offset: const Offset(0, 20),
                      blurRadius: 10,
                      spreadRadius: -12,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -50,
                      left: 20,
                      child: Image.asset(
                        weatherImage,
                        width: 170,
                        height: 170,
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 20,
                      right: 20,
                      child: Text(
                        widget.weatherData.weatherDescription,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: themeProvider.textColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Text(
                        '${widget.weatherData.temperature}°',
                        style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                    ),
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
                        Text(
                          'Vitesse du Vent',
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Image.asset('assets/windspeed.png'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.weatherData.windSpeed} km/h',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 17,  
                          ),
                        ),
                      ],
                    ),
                    // Humidité
                    Column(
                      children: [
                        Text(
                          'Humidité',
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Image.asset('assets/humidity1.png'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.weatherData.humidity,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 17,  
                          ),
                        ),
                      ],
                    ),
                    // Température max
                    Column(
                      children: [
                        Text(
                          'Temp_max',
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Image.asset('assets/max-temp.png'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.weatherData.temp_max}°',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 17,  
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Deuxième rangée d'icônes
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Précipitations
                    Column(
                      children: [
                        Text(
                          'Précipitation',
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,  
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Image.asset('assets/moderaterainattimes.png'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.weatherData.precipitation} mm',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 17,  
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          'Visibilité',
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Image.asset('assets/windspeed1.png'),
                        ),
                        const SizedBox(height: 8),
                         Text(
                           '${widget.weatherData.visibility / 1000} km',
                            style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 17, 
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          'Temps min',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor.withOpacity(0.8),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Image.asset('assets/humidity.png'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.weatherData.temp_max}°',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeProvider.textColor,
                            fontSize: 17, 
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // Carte pour les informations supplémentaires (VENT, HUMIDITÉ, TEMP_MAX)
              Card(
                elevation: 0,
                color: themeProvider.cardColor.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VENT',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.air, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Vitesse' ,
                          style: TextStyle(fontSize: 18,)
                          ),
                          Spacer(),
                          Text('${widget.weatherData.windSpeed} m/s',style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.water_drop,color: Colors.blue,),
                          SizedBox(width: 8),
                          Text('Humidité',style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Text('${widget.weatherData.humidity}%',style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.thermostat, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Temp_max',style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Text('${widget.weatherData.temp_max} K',style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Carte pour le lever et le coucher du soleil
              Card(
                elevation: 0,
                color: themeProvider.cardColor.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOLEIL',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Lever',style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Text(
                            style: TextStyle(fontSize: 18),
                            DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                widget.weatherData.sunrise * 1000,
                              ),
                            ), // Lever du soleil
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.nightlight_round, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Coucher',style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Text(
                            style: TextStyle(fontSize: 18),
                            DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                widget.weatherData.sunset * 1000,

                              ),
                            ), // Coucher du soleil
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Carte pour les détails supplémentaires (VISIBILITÉ, PRÉCIPITATIONS, HUMIDITÉ)
              Card(
                elevation: 0,
                color: themeProvider.cardColor.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DÉTAILS',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Visibilité',style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Text('${widget.weatherData.visibility / 1000} km',style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.cloud, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Précipitations',style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Text(
                            widget.weatherData.precipitation != null
                                ? '${widget.weatherData.precipitation} mm'
                                : '0 mm',             style: TextStyle(fontSize: 18)
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.water, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Humidité',style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Text('${widget.weatherData.humidity}%',style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Bouton "Voir sur Google Maps"
              Center(
                child: ElevatedButton.icon(
                  onPressed: openGoogleMaps,
                  icon: const Icon(Icons.location_on, color: Colors.white),
                  label: const Text(
                    "Voir sur Google Maps",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWeatherImage(String weatherDescription) {
    String description = weatherDescription.toLowerCase();

    switch (description) {
      case 'clear sky':
      case 'ciel dégagé':
        return 'assets/clear.png';
      case 'few clouds':
      case 'quelques nuages':
      case 'partiellement nuageux':
      case 'peu nuageux':
      case 'scattered clouds':
      case 'nuages épars':
      case 'broken clouds':
      case 'nuages fragmentés':
        return 'assets/partlycloudy.png';
      case 'nuageux':
        return 'assets/cloud1.png';
      case 'shower rain':
      case 'averses de pluie':
      case 'rain':
      case 'pluie':
        return 'assets/moderaterainattimes.png';
      case 'thunderstorm':
      case 'orage':
        return 'assets/windspeed.png';
      case 'snow':
      case 'neige':
        return 'assets/hail.png';
      default:
        return 'assets/humidity.png';
    }
  }
}