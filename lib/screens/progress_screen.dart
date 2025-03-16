import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city_model.dart';
import '../services/weather_api.dart';
import '../utils/constantes.dart';
import '../models/theme_provider.dart';
import '../widgets/weather_details.dart';

List<String> messages = [
  "Nous téléchargeons les données...",
  "C'est presque fini...",
  "Plus que quelques secondes..."
];

List<String> cities = ['Dakar', 'Canada', 'Reykjavik', 'Québec', 'Moscou', 'Singapour', 'Matam', 'Paris', 'Kédougou', 'Marrakech'];

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<WeatherData> weatherDataList = [];
  double progressValue = 0.0;
  int messageIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    fetchDataForCities();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      setState(() {
        messageIndex = (messageIndex + 1) % messages.length;
      });
    });
  }

  String getMessage() {
    return messages[messageIndex];
  }

  void fetchDataForCities() async {
    int index = 0;
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (index >= cities.length) {
        timer.cancel();
        return;
      }
      String city = cities[index];
      index++;

      WeatherAPI.fetchWeatherData(city).then((weatherData) {
        setState(() {
          weatherDataList.add(weatherData);
          progressValue = weatherDataList.length / cities.length;
        });
      }).catchError((e) {
        print('Erreur lors de la récupération des données météo pour $city: $e');
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constantes myConst = Constantes();
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (progressValue < 1.0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: LinearProgressIndicator(
                    value: progressValue.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Colors.blueAccent
                          : Colors.lightBlue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (progressValue >= 1.0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      weatherDataList.clear();
                      fetchDataForCities();
                      progressValue = 0.0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.blueAccent
                        : Colors.lightBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Recommencer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              if (progressValue < 1.0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        color: themeProvider.textColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        getMessage(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              if (progressValue >= 1.0)
                Expanded(
                  child: ListView.builder(
                    itemCount: weatherDataList.length,
                    itemBuilder: (context, index) {
                      WeatherData weatherData = weatherDataList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeatherDetails(
                                weatherData: weatherData,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: themeProvider.cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  weatherData.cityName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: themeProvider.textColor,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Image.asset(
                                      _getWeatherImage(weatherData.weatherDescription),
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${weatherData.temperature}°C',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: themeProvider.textColor,
                                          ),
                                        ),
                                        Text(
                                          'Min: ${weatherData.temp_min}°C  Max: ${weatherData.temp_max}°C',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: themeProvider.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Description: ${weatherData.weatherDescription}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: themeProvider.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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