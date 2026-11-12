import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/alert_history_service.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';

class AlertsHistoryScreen extends StatefulWidget {
  const AlertsHistoryScreen({super.key});

  @override
  State<AlertsHistoryScreen> createState() => _AlertsHistoryScreenState();
}

class _AlertsHistoryScreenState extends State<AlertsHistoryScreen> {
  List<AlertRecord> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    final alerts = await AlertHistoryService.getAlerts();
    setState(() {
      _alerts = alerts;
      _isLoading = false;
    });
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(context, 'clear_all_alerts_title')),
        content: Text(tr(context, 'clear_all_alerts_desc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr(context, 'cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(tr(context, 'clear')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AlertHistoryService.clearAlerts();
      _loadAlerts();
    }
  }

  /// Regenerates the display text for an alert type in the current
  /// language, rather than relying on text stored at the time it fired.
  ({String title, String body}) _textFor(BuildContext context, String type) {
    switch (type) {
      case 'high_risk':
      default:
        return (
          title: tr(context, 'high_risk_alert_title'),
          body: tr(context, 'high_risk_alert_body'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'alert_history_title')),
        actions: [
          if (_alerts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearAll,
              tooltip: tr(context, 'clear'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alerts.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      tr(context, 'no_alerts_yet'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _alerts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final alert = _alerts[index];
                    final text = _textFor(context, alert.type);
                    return FadeSlideIn(
                      index: index,
                      staggerStep: const Duration(milliseconds: 40),
                      child: Card(
                        color: Colors.red.withOpacity(0.06),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: const CircleAvatar(
                            backgroundColor: Color(0x1AD32F2F),
                            child: Icon(Icons.warning_amber_rounded, color: Colors.red),
                          ),
                          title: Text(
                            text.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(text.body),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('d MMM yyyy, h:mm a').format(alert.timestamp),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}