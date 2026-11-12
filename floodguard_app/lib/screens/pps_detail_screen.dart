import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/pps_data.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';

class PpsDetailScreen extends StatelessWidget {
  final PpsCentre centre;
  final double? distanceKm;

  const PpsDetailScreen({super.key, required this.centre, this.distanceKm});

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.deepOrange;
      case 'Moderate':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _translatedSeverity(BuildContext context, String severity) {
    switch (severity) {
      case 'Critical':
        return tr(context, 'severity_critical');
      case 'High':
        return tr(context, 'severity_high');
      case 'Moderate':
        return tr(context, 'severity_moderate');
      default:
        return tr(context, 'severity_low');
    }
  }

  // Launches directions directly instead of gating on canLaunchUrl, since
  // canLaunchUrl reports false negatives on Android 11+ when the manifest's
  // <queries> block doesn't declare browser visibility. If launchUrl itself
  // fails, that's a real failure, so we show the user an error instead of
  // silently doing nothing.
  Future<void> _openDirections(BuildContext context) async {
    final url = Uri.parse(
      'https://www.openstreetmap.org/directions?to=${centre.latitude}%2C${centre.longitude}',
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(context, 'error_directions_failed'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final occupancyPct = (centre.occupancyRate * 100).clamp(0, 100);

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'centre_details_title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeSlideIn(
              index: 0,
              child: Text(
                centre.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            FadeSlideIn(
              index: 0,
              child: Text(
                '${centre.district}, ${centre.state}',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            if (distanceKm != null)
              FadeSlideIn(
                index: 1,
                child: Chip(
                  avatar: const Icon(Icons.directions_walk, size: 18),
                  label: Text('${distanceKm!.toStringAsFixed(1)} ${tr(context, 'km_away')}'),
                ),
              ),
            const SizedBox(height: 16),
            FadeSlideIn(
              index: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_pin, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(child: Text(centre.address)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeSlideIn(
              index: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr(context, 'capacity_label'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('${centre.currentOccupancy} / ${centre.capacity} ${tr(context, 'occupied')}'),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: centre.occupancyRate.clamp(0, 1),
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          color: occupancyPct > 90 ? Colors.red : Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${occupancyPct.toStringAsFixed(0)}% ${tr(context, 'full_pct')}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeSlideIn(
              index: 4,
              child: Card(
                color: _severityColor(centre.nearbySeverity).withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: _severityColor(centre.nearbySeverity)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${tr(context, 'nearby_severity_label')}: '
                          '${_translatedSeverity(context, centre.nearbySeverity)}\n'
                          '${tr(context, 'nearby_severity_note')}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeSlideIn(
              index: 5,
              child: ElevatedButton.icon(
                onPressed: () => _openDirections(context),
                icon: const Icon(Icons.directions),
                label: Text(tr(context, 'get_directions')),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}