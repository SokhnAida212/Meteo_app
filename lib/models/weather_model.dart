class WeatherData {
  final String cityName;
  final double latitude;
  final double longitude;
  final String temperature;
  final String weatherDescription;
  final String windSpeed;
  final String humidity;
  final String temp_max;
  final String temp_min;
  final double precipitation;
  final int visibility;
  final int pressure;
  final String feels_like;
  final int sunrise;
  final int sunset;
  final int clouds;

  WeatherData({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.weatherDescription,
    required this.windSpeed,
    required this.humidity,
    required this.temp_max,
    required this.temp_min,
    required this.precipitation,
    required this.visibility,
    required this.pressure,
    required this.feels_like,
    required this.sunrise,
    required this.sunset,
    required this.clouds,
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
      temp_min: (json['main']['temp_min'] - 273.15).toStringAsFixed(0),
      precipitation: json['rain'] != null ? json['rain']['1h'].toDouble() : 0.0,
      visibility: json['visibility'] ?? 0,
      pressure: json['main']['pressure'] ?? 0,
      feels_like: (json['main']['feels_like'] - 273.15).toStringAsFixed(0),
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      clouds: json['clouds']['all'] ?? 0,
    );
  }
}