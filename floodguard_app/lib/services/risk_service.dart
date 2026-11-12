import 'dart:convert';
import 'package:http/http.dart' as http;

class RiskResult {
  final String floodRisk;
  final Map<String, dynamic> confidence;

  RiskResult({required this.floodRisk, required this.confidence});
}

class RiskService {
  // 10.0.2.2 is the Android emulator's alias for your computer's localhost
  static const String _baseUrl = 'http://10.0.2.2:5000';

  static Future<RiskResult> predict({
    required double rainfallMm,
    required double temperatureC,
    required double humidityPct,
    required double windSpeedKmh,
    required double cloudCoverPct,
    required double waterLevelM,
    required double waterDischargeM3s,
    required int alertLevelEncoded,
  }) async {
    final now = DateTime.now();
    final month = now.month;
    final isMonsoon = (month == 11 || month == 12 || month == 1 || month == 2) ? 1 : 0;
    final seasonEncoded = isMonsoon == 1 ? 1 : 0;

    final body = {
      'Year': now.year,
      'Month': month,
      'Is_Monsoon': isMonsoon,
      'Rainfall_mm': rainfallMm,
      'Rainfall_7day_rolling': rainfallMm, // single reading used as proxy
      'Temperature_C': temperatureC,
      'Humidity_pct': humidityPct,
      'Wind_Speed_kmh': windSpeedKmh,
      'Cloud_Cover_pct': cloudCoverPct,
      'Water_Level_m': waterLevelM,
      'Water_Discharge_m3s': waterDischargeM3s,
      'Alert_Level_Encoded': alertLevelEncoded,
      'Season_Encoded': seasonEncoded,
    };

    // TEMP DEBUG — remove once the water condition bug is confirmed fixed
    print('DEBUG: Sending body: ${jsonEncode(body)}');

    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      // Thrown as a translation key, not raw English — the UI layer
      // translates this via tr(context, key) before showing it.
      throw Exception('error_prediction_failed');
    }

    final data = jsonDecode(response.body);

    return RiskResult(
      floodRisk: data['flood_risk'],
      confidence: data['confidence'] ?? {},
    );
  }
}