import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../services/risk_service.dart';
import '../services/notification_service.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';

enum WaterCondition { normal, rising, high }

class RiskDetectionScreen extends StatefulWidget {
  const RiskDetectionScreen({super.key});

  @override
  State<RiskDetectionScreen> createState() => _RiskDetectionScreenState();
}

class _RiskDetectionScreenState extends State<RiskDetectionScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  WeatherData? _weather;
  RiskResult? _result;
  WaterCondition? _selectedCondition;

  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('error_location_services_off');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('error_location_permission_denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('error_location_permission_denied_forever');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Maps the simple 3-button choice to the 3 fields the model needs
  // that we cannot get from GPS or weather data alone.
  Map<String, num> _waterValuesFor(WaterCondition condition) {
    switch (condition) {
      case WaterCondition.normal:
        return {
          'waterLevelM': 1.5,
          'waterDischargeM3s': 40,
          'alertLevelEncoded': 0,
        };
      case WaterCondition.rising:
        return {
          'waterLevelM': 3.0,
          'waterDischargeM3s': 100,
          'alertLevelEncoded': 1,
        };
      case WaterCondition.high:
        return {
          'waterLevelM': 5.0,
          'waterDischargeM3s': 220,
          'alertLevelEncoded': 2,
        };
    }
  }

  // Simulates extreme weather conditions to demonstrate the full High-risk
  // alert flow (prediction + notification) without needing to wait for
  // genuinely severe weather during a live demo or examiner session.
  // This is a deliberate, documented feature (tracker 7.10) — not
  // leftover debug code.
  Future<void> _runSimulation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await RiskService.predict(
        rainfallMm: 120,
        temperatureC: 26,
        humidityPct: 95,
        windSpeedKmh: 30,
        cloudCoverPct: 100,
        waterLevelM: 6.5,
        waterDischargeM3s: 300,
        alertLevelEncoded: 2,
      );

      final testWeather = WeatherData(
        rainfallMm: 120,
        temperatureC: 26,
        humidityPct: 95,
        windSpeedKmh: 30,
        cloudCoverPct: 100,
      );

      setState(() {
        _weather = testWeather;
        _result = result;
      });

      await NotificationService.showHighRiskAlert(
        riskLevel: result.floodRisk,
        districtHint: null,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runPrediction() async {
    if (_selectedCondition == null) {
      setState(() {
        _errorMessage = tr(context, 'select_water_condition_error');
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final position = await _getLocation();
      final weather = await WeatherService.fetchWeather(
        position.latitude,
        position.longitude,
      );

      final waterValues = _waterValuesFor(_selectedCondition!);

      final result = await RiskService.predict(
        rainfallMm: weather.rainfallMm,
        temperatureC: weather.temperatureC,
        humidityPct: weather.humidityPct,
        windSpeedKmh: weather.windSpeedKmh,
        cloudCoverPct: weather.cloudCoverPct,
        waterLevelM: waterValues['waterLevelM']!.toDouble(),
        waterDischargeM3s: waterValues['waterDischargeM3s']!.toDouble(),
        alertLevelEncoded: waterValues['alertLevelEncoded']!.toInt(),
      );

      setState(() {
        _weather = weather;
        _result = result;
      });

      await NotificationService.showHighRiskAlert(
        riskLevel: result.floodRisk,
        districtHint: null,
      );
    } catch (e) {
      setState(() {
        _errorMessage = tr(context, e.toString().replaceFirst('Exception: ', ''));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _riskColor(String risk) {
    switch (risk) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  /// The Flask API always returns 'High' / 'Medium' / 'Low' in English.
  /// This maps that fixed backend value to the current app language.
  String _translatedRisk(BuildContext context, String risk) {
    switch (risk) {
      case 'High':
        return tr(context, 'risk_high');
      case 'Medium':
        return tr(context, 'risk_medium');
      default:
        return tr(context, 'risk_low');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'risk_detection_title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              tr(context, 'water_condition_heading'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              tr(context, 'water_condition_desc'),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            FadeSlideIn(
              index: 0,
              child: _WaterConditionButton(
                label: tr(context, 'water_normal'),
                description: tr(context, 'water_normal_desc'),
                icon: Icons.water_drop_outlined,
                color: Colors.green,
                isSelected: _selectedCondition == WaterCondition.normal,
                onTap: () => setState(() => _selectedCondition = WaterCondition.normal),
              ),
            ),
            const SizedBox(height: 10),
            FadeSlideIn(
              index: 1,
              child: _WaterConditionButton(
                label: tr(context, 'water_rising'),
                description: tr(context, 'water_rising_desc'),
                icon: Icons.water_drop,
                color: Colors.orange,
                isSelected: _selectedCondition == WaterCondition.rising,
                onTap: () => setState(() => _selectedCondition = WaterCondition.rising),
              ),
            ),
            const SizedBox(height: 10),
            FadeSlideIn(
              index: 2,
              child: _WaterConditionButton(
                label: tr(context, 'water_high'),
                description: tr(context, 'water_high_desc'),
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
                isSelected: _selectedCondition == WaterCondition.high,
                onTap: () => setState(() => _selectedCondition = WaterCondition.high),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runPrediction,
              icon: const Icon(Icons.my_location),
              label: Text(_isLoading ? tr(context, 'checking') : tr(context, 'check_flood_risk')),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _runSimulation,
              icon: const Icon(Icons.auto_fix_high),
              label: Text(tr(context, 'simulate_extreme_conditions')),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                tr(context, 'simulate_extreme_conditions_subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
            if (_result != null && _weather != null) ...[
              const SizedBox(height: 24),
              PopIn(
                child: Card(
                  color: _riskColor(_result!.floodRisk).withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tr(context, 'flood_risk_label')}: ${_translatedRisk(context, _result!.floodRisk)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _riskColor(_result!.floodRisk),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${tr(context, 'confidence_label')} — ${tr(context, 'risk_high')}: '
                          '${(_result!.confidence['High'] * 100).toStringAsFixed(1)}%  '
                          '${tr(context, 'risk_medium')}: ${(_result!.confidence['Medium'] * 100).toStringAsFixed(1)}%  '
                          '${tr(context, 'risk_low')}: ${(_result!.confidence['Low'] * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const Divider(height: 24),
                        Text('${tr(context, 'rainfall')}: ${_weather!.rainfallMm} mm'),
                        Text('${tr(context, 'temperature')}: ${_weather!.temperatureC}°C'),
                        Text('${tr(context, 'humidity')}: ${_weather!.humidityPct}%'),
                        Text('${tr(context, 'wind')}: ${_weather!.windSpeedKmh.toStringAsFixed(1)} km/h'),
                        Text('${tr(context, 'cloud_cover')}: ${_weather!.cloudCoverPct}%'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WaterConditionButton extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _WaterConditionButton({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withOpacity(0.08) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}