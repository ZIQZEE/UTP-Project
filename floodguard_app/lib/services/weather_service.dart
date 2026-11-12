import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double rainfallMm;
  final double temperatureC;
  final double humidityPct;
  final double windSpeedKmh;
  final double cloudCoverPct;
  final String? description;
  final String? icon;
  final String? cityName;
  final double feelsLikeC;
  final double pressureHpa;
  final double visibilityKm;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherData({
    required this.rainfallMm,
    required this.temperatureC,
    required this.humidityPct,
    required this.windSpeedKmh,
    required this.cloudCoverPct,
    this.description,
    this.icon,
    this.cityName,
    this.feelsLikeC = 0,
    this.pressureHpa = 0,
    this.visibilityKm = 0,
    this.sunrise,
    this.sunset,
  });
}

class ForecastEntry {
  final DateTime time;
  final double temperatureC;
  final double rainfallMm;
  final String description;
  final String icon;

  ForecastEntry({
    required this.time,
    required this.temperatureC,
    required this.rainfallMm,
    required this.description,
    required this.icon,
  });
}

class WeatherService {
  static const String _apiKey = String.fromEnvironment('OPENWEATHER_API_KEY');

  static Future<WeatherData> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      // Thrown as a translation key, not raw English — the UI layer
      // translates this via tr(context, key) before showing it.
      throw Exception('error_fetch_weather_failed');
    }

    final data = jsonDecode(response.body);
    final weatherArr = data['weather'] as List?;
    final main = data['main'] ?? {};
    final wind = data['wind'] ?? {};
    final clouds = data['clouds'] ?? {};
    final sys = data['sys'] ?? {};

    // OpenWeatherMap returns sunrise/sunset as UTC epoch seconds, plus a
    // separate 'timezone' field: the target location's UTC offset in
    // seconds. Using DateTime.fromMillisecondsSinceEpoch() directly would
    // silently convert using the DEVICE's system timezone instead of the
    // queried location's, which is wrong whenever they differ (e.g. an
    // emulator left on UTC while GPS is spoofed to Kuala Lumpur). Adding
    // the location's real offset first and flagging the result isUtc:
    // true gives the correct local time for that location regardless of
    // what timezone the device itself is set to.
    final tzOffsetSeconds = (data['timezone'] ?? 0) as int;

    return WeatherData(
      rainfallMm: ((data['rain']?['1h'] ?? 0.0) as num).toDouble(),
      temperatureC: ((main['temp'] ?? 0.0) as num).toDouble(),
      humidityPct: ((main['humidity'] ?? 0.0) as num).toDouble(),
      windSpeedKmh: ((wind['speed'] ?? 0.0) as num).toDouble() * 3.6,
      cloudCoverPct: ((clouds['all'] ?? 0.0) as num).toDouble(),
      description: weatherArr != null && weatherArr.isNotEmpty
          ? weatherArr[0]['description']
          : null,
      icon: weatherArr != null && weatherArr.isNotEmpty
          ? weatherArr[0]['icon']
          : null,
      cityName: data['name'],
      feelsLikeC: ((main['feels_like'] ?? main['temp'] ?? 0.0) as num).toDouble(),
      pressureHpa: ((main['pressure'] ?? 0) as num).toDouble(),
      visibilityKm: ((data['visibility'] ?? 10000) as num).toDouble() / 1000,
      sunrise: sys['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              ((sys['sunrise'] as int) + tzOffsetSeconds) * 1000,
              isUtc: true,
            )
          : null,
      sunset: sys['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              ((sys['sunset'] as int) + tzOffsetSeconds) * 1000,
              isUtc: true,
            )
          : null,
    );
  }

  /// Fetches a forecast covering roughly the next 48–72 hours, using
  /// OpenWeatherMap's free 5-day / 3-hour forecast endpoint. Returns
  /// entries spaced 3 hours apart.
  static Future<List<ForecastEntry>> fetchForecast(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('error_fetch_forecast_failed');
    }

    final data = jsonDecode(response.body);
    final list = data['list'] as List;
    final tzOffsetSeconds = (data['city']?['timezone'] ?? 0) as int;

    // Take up to 24 entries (24 x 3h = 72 hours)
    final entries = list.take(24).map<ForecastEntry>((item) {
      final weatherArr = item['weather'] as List;
      final main = item['main'] ?? {};
      return ForecastEntry(
        time: DateTime.fromMillisecondsSinceEpoch(
          ((item['dt'] as int) + tzOffsetSeconds) * 1000,
          isUtc: true,
        ),
        temperatureC: ((main['temp'] ?? 0.0) as num).toDouble(),
        rainfallMm: ((item['rain']?['3h'] ?? 0.0) as num).toDouble(),
        description: weatherArr.isNotEmpty ? weatherArr[0]['description'] : '',
        icon: weatherArr.isNotEmpty ? weatherArr[0]['icon'] : '01d',
      );
    }).toList();

    return entries;
  }
}