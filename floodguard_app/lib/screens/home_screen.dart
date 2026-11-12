import 'package:flutter/material.dart';
import 'risk_detection_screen.dart';
import 'pps_locator_screen.dart';
import 'announcements_screen.dart';
import 'alerts_history_screen.dart';
import 'flood_timeline_screen.dart';
import 'weather_screen.dart';
import 'chatbot_screen.dart';
import 'settings_screen.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';

class _Feature {
  final IconData icon;
  final Color color;
  final String titleKey;
  final String subtitleKey;
  final WidgetBuilder builder;

  const _Feature({
    required this.icon,
    required this.color,
    required this.titleKey,
    required this.subtitleKey,
    required this.builder,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<_Feature> _features = [
    _Feature(
      icon: Icons.warning_amber_rounded,
      color: const Color(0xFFD32F2F),
      titleKey: 'feature_risk_title',
      subtitleKey: 'feature_risk_subtitle',
      builder: (context) => const RiskDetectionScreen(),
    ),
    _Feature(
      icon: Icons.map_outlined,
      color: const Color(0xFF0E8A82),
      titleKey: 'feature_pps_title',
      subtitleKey: 'feature_pps_subtitle',
      builder: (context) => const PpsLocatorScreen(),
    ),
    _Feature(
      icon: Icons.campaign_outlined,
      color: const Color(0xFF0B5FA5),
      titleKey: 'feature_announcements_title',
      subtitleKey: 'feature_announcements_subtitle',
      builder: (context) => const AnnouncementsScreen(),
    ),
    _Feature(
      icon: Icons.notifications_active_outlined,
      color: const Color(0xFFC2185B),
      titleKey: 'feature_alerts_title',
      subtitleKey: 'feature_alerts_subtitle',
      builder: (context) => const AlertsHistoryScreen(),
    ),
    _Feature(
      icon: Icons.timeline,
      color: const Color(0xFF6A1B9A),
      titleKey: 'feature_timeline_title',
      subtitleKey: 'feature_timeline_subtitle',
      builder: (context) => const FloodTimelineScreen(),
    ),
    _Feature(
      icon: Icons.wb_sunny_outlined,
      color: const Color(0xFFF57C00),
      titleKey: 'feature_weather_title',
      subtitleKey: 'feature_weather_subtitle',
      builder: (context) => const WeatherScreen(),
    ),
    _Feature(
      icon: Icons.chat_bubble_outline,
      color: const Color(0xFF2E7D32),
      titleKey: 'feature_chatbot_title',
      subtitleKey: 'feature_chatbot_subtitle',
      builder: (context) => const ChatbotScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int i = 0; i < _features.length; i++) ...[
            FadeSlideIn(index: i, child: _FeatureCard(feature: _features[i])),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: feature.builder),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: feature.color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(feature.icon, color: feature.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(context, feature.titleKey),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tr(context, feature.subtitleKey),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}