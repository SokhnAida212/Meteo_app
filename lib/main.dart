import 'package:flutter/material.dart';
import 'package:meteo_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'models/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Créez une instance de ThemeProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Thème clair
      darkTheme: ThemeData.dark(), // Thème sombre
      themeMode: themeProvider.themeMode, // Utilisez le mode actuel (clair ou sombre)
      home: SplashScreen(),
    );
  }
}