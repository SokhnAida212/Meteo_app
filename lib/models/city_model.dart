class WeatherData {
  final String cityName;
  final double latitude;
  final double longitude;
  final String temperature;
  final String weatherDescription;
  final String windSpeed;
  final String humidity;
  final String temp_max;
  final double precipitation;
  final int timezone;

  WeatherData({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.weatherDescription,
    required this.windSpeed,
    required this.humidity,
    required this.temp_max,
    required this.precipitation,
    required this.timezone,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'],
      latitude: json['coord']['lat'],
      longitude: json['coord']['lon'],
      temperature: (json['main']['temp'] - 273.15).toStringAsFixed(0),
      weatherDescription: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toString(),
      humidity: json['main']['humidity'].toString(),
      temp_max: (json['main']['temp_max'] - 273.15).toStringAsFixed(0),
      precipitation: json['rain'] != null ? json['rain']['1h'].toDouble() : 0.0,
      timezone: json['timezone'],
    );
  }

}