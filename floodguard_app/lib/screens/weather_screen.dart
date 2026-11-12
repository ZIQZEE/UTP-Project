import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import '../localization/app_strings.dart';
import '../localization/weather_descriptions.dart';
import '../widgets/fade_slide_in.dart';
import 'risk_detection_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  WeatherData? _current;
  List<ForecastEntry> _forecast = [];

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

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

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _getLocation();
      final current = await WeatherService.fetchWeather(position.latitude, position.longitude);
      final forecast = await WeatherService.fetchForecast(position.latitude, position.longitude);

      setState(() {
        _current = current;
        _forecast = forecast;
      });
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

  /// Maps OpenWeatherMap's icon code to a fitting icon + accent color.
  /// Codes end in 'd' (day) or 'n' (night).
  _WeatherVisual _weatherVisual(String? code) {
    if (code == null) return const _WeatherVisual(Icons.wb_sunny, Color(0xFFFFD54F));

    final isNight = code.endsWith('n');
    final group = code.substring(0, 2);

    switch (group) {
      case '01':
        return isNight
            ? const _WeatherVisual(Icons.nightlight_round, Color(0xFFB4C5FF))
            : const _WeatherVisual(Icons.wb_sunny, Color(0xFFFFD54F));
      case '02':
        return isNight
            ? const _WeatherVisual(Icons.cloud, Color(0xFFC5CEFF))
            : const _WeatherVisual(Icons.wb_cloudy, Color(0xFFFFE082));
      case '03':
      case '04':
        return const _WeatherVisual(Icons.cloud, Color(0xFFE0E6ED));
      case '09':
        return const _WeatherVisual(Icons.grain, Color(0xFF90CAF9));
      case '10':
        return const _WeatherVisual(Icons.water_drop, Color(0xFF64B5F6));
      case '11':
        return const _WeatherVisual(Icons.thunderstorm, Color(0xFFCE93D8));
      case '13':
        return const _WeatherVisual(Icons.ac_unit, Color(0xFFB3E5FC));
      case '50':
        return const _WeatherVisual(Icons.blur_on, Color(0xFFCFD8DC));
      default:
        return const _WeatherVisual(Icons.wb_sunny, Color(0xFFFFD54F));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'weather_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadWeather,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadWeather,
                          child: Text(tr(context, 'retry')),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadWeather,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      PopIn(child: _buildCurrentCard()),
                      const SizedBox(height: 22),
                      FadeSlideIn(
                        child: Text(
                          tr(context, 'next_72_hours'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildForecastList(),
                      const SizedBox(height: 22),
                      FadeSlideIn(
                        child: Text(
                          tr(context, 'details'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDetailsGrid(),
                      const SizedBox(height: 22),
                      FadeSlideIn(child: _buildFloodRiskPrompt()),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCurrentCard() {
    final w = _current!;
    final visual = _weatherVisual(w.icon);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryBlue, AppTheme.deepNavy],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Decorative oversized watermark icon for visual depth.
            Positioned(
              right: -30,
              top: -20,
              child: Icon(
                visual.icon,
                size: 190,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              child: Column(
                children: [
                  if (w.cityName != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          w.cityName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: visual.color.withOpacity(0.16),
                      border: Border.all(color: visual.color.withOpacity(0.3), width: 1.4),
                    ),
                    child: Icon(visual.icon, size: 60, color: visual.color),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${w.temperatureC.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  if (w.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        WeatherDescriptions.translate(w.description, AppLocale.of(context).code),
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatPill(icon: Icons.water_drop, label: tr(context, 'rainfall'), value: '${w.rainfallMm} mm', color: const Color(0xFF64B5F6)),
                      _StatPill(icon: Icons.opacity, label: tr(context, 'humidity'), value: '${w.humidityPct.toStringAsFixed(0)}%', color: const Color(0xFF4DD0E1)),
                      _StatPill(icon: Icons.air, label: tr(context, 'wind'), value: '${w.windSpeedKmh.toStringAsFixed(1)} km/h', color: const Color(0xFFB0BEC5)),
                      _StatPill(icon: Icons.cloud, label: tr(context, 'cloud_cover'), value: '${w.cloudCoverPct.toStringAsFixed(0)}%', color: const Color(0xFFC5CAE9)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastList() {
    final cardColor = Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _forecast.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final entry = _forecast[index];
          final visual = _weatherVisual(entry.icon);
          return FadeSlideIn(
            index: index,
            staggerStep: const Duration(milliseconds: 50),
            child: Container(
            width: 96,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('E, ha').format(entry.time),
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: visual.color.withOpacity(0.16),
                  ),
                  child: Icon(visual.icon, color: visual.color, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  '${entry.temperatureC.toStringAsFixed(0)}°C',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                if (entry.rainfallMm > 0)
                  Text(
                    '${entry.rainfallMm.toStringAsFixed(1)}mm',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF1E88E5)),
                  ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildDetailsGrid() {
    final w = _current!;
    final scheme = Theme.of(context).colorScheme;

    final details = [
      _DetailItem(Icons.thermostat, tr(context, 'feels_like'), '${w.feelsLikeC.toStringAsFixed(1)}°C', const Color(0xFFEF5350)),
      _DetailItem(Icons.speed, tr(context, 'pressure'), '${w.pressureHpa.toStringAsFixed(0)} hPa', const Color(0xFF9575CD)),
      _DetailItem(Icons.visibility_outlined, tr(context, 'visibility'), '${w.visibilityKm.toStringAsFixed(1)} km', const Color(0xFF4FC3F7)),
      _DetailItem(
        Icons.wb_twilight,
        tr(context, 'sunrise_sunset'),
        w.sunrise != null && w.sunset != null
            ? '${DateFormat('h:mm a').format(w.sunrise!)} / ${DateFormat('h:mm a').format(w.sunset!)}'
            : '—',
        const Color(0xFFFFB74D),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: details.asMap().entries.map((entry) {
        final i = entry.key;
        final d = entry.value;
        return FadeSlideIn(
          index: i,
          staggerStep: const Duration(milliseconds: 60),
          child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: d.color.withOpacity(0.15),
                ),
                child: Icon(d.icon, size: 18, color: d.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.label, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                    Text(
                      d.value,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: scheme.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFloodRiskPrompt() {
    final w = _current!;
    final rainyEnough = w.rainfallMm > 0 || _forecast.any((f) => f.rainfallMm > 0);

    return Card(
      color: AppTheme.riskHigh.withOpacity(0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RiskDetectionScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.riskHigh.withOpacity(0.15),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: AppTheme.riskHigh),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rainyEnough ? tr(context, 'rain_expected_prompt') : tr(context, 'check_flood_risk_prompt'),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tr(context, 'flood_risk_prompt_subtitle'),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem(this.icon, this.label, this.value, this.color);
}

class _WeatherVisual {
  final IconData icon;
  final Color color;

  const _WeatherVisual(this.icon, this.color);
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
          const SizedBox(height: 1),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60)),
        ],
      ),
    );
  }
}