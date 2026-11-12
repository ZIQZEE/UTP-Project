import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';
import 'announcement_detail_screen.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

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

  /// Picks the field matching the current language, falling back to the
  /// older single-language field name for any pre-existing documents
  /// seeded before bilingual fields were added.
  String _localizedField(Map<String, dynamic> data, String baseName, String locale, {String fallbackKey = ''}) {
    final localizedKey = '${baseName}_$locale';
    if (data[localizedKey] != null) return data[localizedKey];
    final enKey = '${baseName}_en';
    if (data[enKey] != null) return data[enKey];
    if (fallbackKey.isNotEmpty && data[fallbackKey] != null) return data[fallbackKey];
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocale.of(context).code;

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'announcements_title'))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('announcements')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '${tr(context, 'could_not_load_announcements')}\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(tr(context, 'no_announcements')),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final title = _localizedField(data, 'title', locale, fallbackKey: 'title');
              final source = _localizedField(data, 'source', locale, fallbackKey: 'source');
              final body = _localizedField(data, 'body', locale, fallbackKey: 'body');
              final state = data['state'] ?? '';
              final severity = data['severity'] ?? 'Advisory';
              final timestamp = data['timestamp'] as Timestamp?;
              final dateStr = timestamp != null
                  ? DateFormat('d MMM yyyy, h:mm a').format(timestamp.toDate())
                  : '';

              return FadeSlideIn(
                index: index,
                staggerStep: const Duration(milliseconds: 40),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: _severityColor(severity).withOpacity(0.15),
                      child: Icon(Icons.campaign, color: _severityColor(severity)),
                    ),
                    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('$source • $state'),
                        const SizedBox(height: 2),
                        Text(dateStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _severityColor(severity).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _translatedSeverity(context, severity),
                        style: TextStyle(
                          color: _severityColor(severity),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnnouncementDetailScreen(
                            title: title,
                            source: source,
                            state: state,
                            severity: severity,
                            body: body,
                            dateStr: dateStr,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}