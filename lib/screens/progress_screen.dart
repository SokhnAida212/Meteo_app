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
  "Plus que quelques secondes avant d'avoir le résultat..."
];
List<String> cities = ['Canadà', 'chine', 'Matam', 'Paris', 'Kedougou','Dakar'];


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
    Timer.periodic(Duration(seconds: 6), (timer) {
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
          progressValue = weatherDataList.length / cities.length; // Mettre à jour la valeur de la barre de progression
        });
      }).catchError((e) {
        print('Error fetching weather data for $city: $e');
      });
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constantes myConst = Constantes();
    Size size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xffECF8F9),
      appBar: AppBar(
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
                  child: Image.asset('assets/bouton-fleche.png', width: 30, height: 30,color: themeProvider.iconColor,),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset('assets/accueil.png', width: 30, height: 30,color: themeProvider.iconColor,),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (weatherDataList.length >= cities.length)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      weatherDataList.clear();
                      fetchDataForCities();
                      progressValue = 0.0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: themeProvider.textColor,
                  ),
                  child: Text('Recommencer', style: TextStyle(color: Colors.black87, fontSize: 18,fontWeight: FontWeight.bold),),
                ),
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    child: Visibility(
                      visible: progressValue < 1.0,
                      child: LinearProgressIndicator(
                        value: progressValue.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              if (progressValue < 1.0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getMessage(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor,
                    ),
                  ),
                ),
              if (progressValue >= 1.0)
                Expanded(
                  child: ListView.builder(
                    itemCount: weatherDataList.length,
                    itemBuilder: (context, index) {
                      WeatherData weatherData = weatherDataList[index];
                      IconData weatherIcon;
                      switch (weatherData.weatherDescription.toLowerCase()) {
                        case 'clear sky':
                          weatherIcon = Icons.wb_sunny;
                          break;
                        case 'few clouds':
                        case 'scattered clouds':
                        case 'broken clouds':
                          weatherIcon = Icons.cloud;
                          break;
                        case 'shower rain':
                        case 'rain':
                          weatherIcon = Icons.beach_access;
                          break;
                        case 'thunderstorm':
                          weatherIcon = Icons.flash_on;
                          break;
                        case 'snow':
                          weatherIcon = Icons.ac_unit;
                          break;
                        default:
                          weatherIcon = Icons.cloud;
                          break;
                      }
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
                          child: ListTile(
                            leading: Icon(weatherIcon, size: 36, color: Colors.blue),
                            title: Text(
                              weatherData.cityName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: themeProvider.textColor,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.thermostat_rounded, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      'Température: ${weatherData.temperature}°C',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.cloud_rounded, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      'Description: ${weatherData.weatherDescription}',
                                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                    ),
                                  ],
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



}
