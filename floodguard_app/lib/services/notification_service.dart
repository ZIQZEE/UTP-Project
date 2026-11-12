import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'alert_history_service.dart';
import '../localization/app_strings.dart';
import '../localization/locale_controller.dart';

/// Handles device notifications for FloodGuard Malaysia.
///
/// Per the project report: "Firebase Cloud Messaging sends an alert when
/// a user's district is classified as High risk." This service triggers
/// that alert locally, the moment a risk check returns High. Full 24/7
/// background monitoring requires the Flask API to run on a cloud server
/// continuously (documented as future work, Phase 4 — AWS/Azure migration).
/// This implementation demonstrates the complete alert logic end-to-end;
/// only the hosting location of the prediction server changes later.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings: settings);

    // Android 13+ requires explicit runtime permission for notifications.
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showHighRiskAlert({
    required String riskLevel,
    required String? districtHint,
  }) async {
    if (riskLevel != 'High') return;

    // Respect the "High-risk alerts" toggle in Settings (saved under this
    // same key by settings_screen.dart). Without this check the toggle
    // only ever saved a preference that nothing read back, so alerts kept
    // firing even when the user had turned them off.
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    if (!notificationsEnabled) return;

    // This service runs outside any screen's BuildContext, so it reads
    // the current language directly from LocaleController rather than
    // via tr(context, ...).
    final locale = LocaleController.locale.value;
    final title = AppStrings.of('high_risk_alert_title', locale);
    final baseBody = AppStrings.of('high_risk_alert_body', locale);
    final message = districtHint != null ? '$baseBody ($districtHint)' : baseBody;

    const androidDetails = AndroidNotificationDetails(
      'flood_risk_channel',
      'Flood Risk Alerts',
      channelDescription: 'Alerts triggered when flood risk is classified as High',
      importance: Importance.max,
      priority: Priority.high,
      color: Color.fromARGB(255, 211, 47, 47),
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: 0,
      title: title,
      body: message,
      notificationDetails: details,
    );

    // Save just the alert type — the Alerts History screen regenerates
    // the title/body text via tr() using whatever language is active
    // when it's viewed, not the language active when this fired.
    await AlertHistoryService.addAlert('high_risk');
  }
}