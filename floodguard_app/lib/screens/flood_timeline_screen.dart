import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/flood_events_data.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';

class FloodTimelineScreen extends StatefulWidget {
  const FloodTimelineScreen({super.key});

  @override
  State<FloodTimelineScreen> createState() => _FloodTimelineScreenState();
}

class _FloodTimelineScreenState extends State<FloodTimelineScreen> {
  String? _selectedState;

  static const List<String> _states = ['Kelantan', 'Terengganu', 'Selangor', 'Johor'];

  // Built from the actual distinct values in the EM-DAT dataset (checked
  // directly against the source file, not guessed) so every real value
  // that can appear has an exact translation, across all 4 languages.
  static const Map<String, Map<String, String>> _subtypeTranslations = {
    'Flood (General)': {
      'ms': 'Banjir (Am)',
      'zh': '洪水（一般）',
      'ta': 'வெள்ளம் (பொது)',
    },
    'Riverine flood': {
      'ms': 'Banjir Sungai',
      'zh': '河流洪水',
      'ta': 'ஆற்று வெள்ளம்',
    },
    'Flash flood': {
      'ms': 'Banjir Kilat',
      'zh': '山洪暴发',
      'ta': 'திடீர் வெள்ளம்',
    },
  };

  static const Map<String, Map<String, String>> _causeTranslations = {
    'Heavy rain': {
      'ms': 'Hujan Lebat',
      'zh': '大雨',
      'ta': 'கனமழை',
    },
    'Heavy rains': {
      'ms': 'Hujan Lebat',
      'zh': '大雨',
      'ta': 'கனமழை',
    },
    'Heavy rains, Tropical Depression TWENTYNINE': {
      'ms': 'Hujan Lebat, Depresi Tropika TWENTYNINE',
      'zh': '大雨，热带低压TWENTYNINE',
      'ta': 'கனமழை, வெப்பமண்டல தாழ்வுமண்டலம் TWENTYNINE',
    },
    'Heavy monsoonal rains': {
      'ms': 'Hujan Monsun Lebat',
      'zh': '强季风降雨',
      'ta': 'கன பருவமழை',
    },
    'Torrential rain': {
      'ms': 'Hujan Lebat Berterusan',
      'zh': '暴雨',
      'ta': 'கொட்டும் மழை',
    },
    'Torrential rains': {
      'ms': 'Hujan Lebat Berterusan',
      'zh': '暴雨',
      'ta': 'கொட்டும் மழை',
    },
    'Brief torrential rain': {
      'ms': 'Hujan Lebat Berterusan Seketika',
      'zh': '短暂暴雨',
      'ta': 'குறுகிய கொட்டும் மழை',
    },
    'Continous rains': {
      'ms': 'Hujan Berterusan',
      'zh': '持续降雨',
      'ta': 'தொடர்ச்சியான மழை',
    },
    'Monsoonal rains': {
      'ms': 'Hujan Monsun',
      'zh': '季风降雨',
      'ta': 'பருவமழை',
    },
    'Monsoonal rain': {
      'ms': 'Hujan Monsun',
      'zh': '季风降雨',
      'ta': 'பருவமழை',
    },
    'Not specified': {
      'ms': 'Tidak Dinyatakan',
      'zh': '未说明',
      'ta': 'குறிப்பிடப்படவில்லை',
    },
  };

  String _translatedSubtype(BuildContext context, String subtype) {
    final locale = AppLocale.of(context).code;
    if (locale == 'en') return subtype;
    return _subtypeTranslations[subtype]?[locale] ?? subtype;
  }

  String _translatedCause(BuildContext context, String cause) {
    final locale = AppLocale.of(context).code;
    if (locale == 'en') return cause;
    return _causeTranslations[cause]?[locale] ?? cause;
  }

  Color _subtypeColor(String subtype) {
    if (subtype.toLowerCase().contains('flash')) return Colors.red;
    if (subtype.toLowerCase().contains('riverine')) return Colors.deepOrange;
    return Colors.blue;
  }

  String _formatDateRange(FloodEvent e) {
    final startFmt = DateFormat('d MMM yyyy');
    final endFmt = DateFormat('d MMM yyyy');
    if (e.startDate == e.endDate) {
      return startFmt.format(e.startDate);
    }
    return '${startFmt.format(e.startDate)} – ${endFmt.format(e.endDate)}';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedState == null
        ? floodEvents
        : floodEvents.where((e) => e.states.contains(_selectedState)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'flood_timeline_title'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _StateChip(
                    label: tr(context, 'all_states'),
                    isSelected: _selectedState == null,
                    onTap: () => setState(() => _selectedState = null),
                  ),
                  const SizedBox(width: 8),
                  for (final state in _states) ...[
                    _StateChip(
                      label: state,
                      isSelected: _selectedState == state,
                      onTap: () => setState(() => _selectedState = state),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${filtered.length} ${filtered.length == 1 ? tr(context, 'recorded_event') : tr(context, 'recorded_events')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                const Text(
                  'Source: EM-DAT',
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(tr(context, 'no_events_for_state')))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final event = filtered[index];
                      final color = _subtypeColor(event.subtype);
                      final isLast = index == filtered.length - 1;

                      return FadeSlideIn(
                        index: index,
                        staggerStep: const Duration(milliseconds: 35),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(0.15),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  _translatedSubtype(context, event.subtype),
                                                  style: TextStyle(
                                                    color: color,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _formatDateRange(event),
                                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            event.location,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${tr(context, 'cause_label')}: ${_translatedCause(context, event.cause)}',
                                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              if (event.deaths > 0) ...[
                                                const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                                                const SizedBox(width: 4),
                                                Text('${event.deaths} ${tr(context, 'deaths_label')}', style: const TextStyle(fontSize: 12)),
                                                const SizedBox(width: 16),
                                              ],
                                              if (event.affected > 0) ...[
                                                const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text('${event.affected} ${tr(context, 'affected_label')}', style: const TextStyle(fontSize: 12)),
                                              ],
                                            ],
                                          ),
                                          Wrap(
                                            spacing: 6,
                                            children: event.states
                                                .map((s) => Chip(
                                                      label: Text(s, style: const TextStyle(fontSize: 10)),
                                                      padding: EdgeInsets.zero,
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      visualDensity: VisualDensity.compact,
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StateChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }
}