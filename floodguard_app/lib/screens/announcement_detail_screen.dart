import 'package:flutter/material.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final String title;
  final String source;
  final String state;
  final String severity;
  final String body;
  final String dateStr;

  const AnnouncementDetailScreen({
    super.key,
    required this.title,
    required this.source,
    required this.state,
    required this.severity,
    required this.body,
    required this.dateStr,
  });

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Warning':
        return Colors.deepOrange;
      case 'Critical':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _translatedSeverity(BuildContext context, String severity) {
    switch (severity) {
      case 'Warning':
        return tr(context, 'severity_warning');
      case 'Critical':
        return tr(context, 'severity_critical');
      default:
        return tr(context, 'severity_advisory');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(severity);

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'announcement_title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeSlideIn(
              index: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _translatedSeverity(context, severity),
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeSlideIn(
              index: 1,
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            FadeSlideIn(
              index: 1,
              child: Text(
                '$source • $state',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 4),
            FadeSlideIn(
              index: 1,
              child: Text(
                dateStr,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const Divider(height: 32),
            FadeSlideIn(
              index: 2,
              child: Text(
                body,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}