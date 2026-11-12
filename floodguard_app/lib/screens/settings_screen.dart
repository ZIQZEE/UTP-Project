import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/theme_controller.dart';
import '../localization/locale_controller.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadAppInfo();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version} (build ${info.buildNumber})';
    });
  }

  Future<void> _setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() => _notificationsEnabled = value);
  }

  void _showAboutSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop, color: Colors.blue, size: 32),
                const SizedBox(width: 10),
                const Text(
                  'FloodGuard Malaysia',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Version $_appVersion', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text(
              'A machine learning-based flood risk prediction and disaster '
              'preparedness platform for Kelantan, Terengganu, Selangor, and '
              'Johor. Built as a Final Year Project at Universiti Teknologi '
              'PETRONAS.',
            ),
            const SizedBox(height: 20),
            const Text('Emergency Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const _ContactRow(label: 'Emergency (Police / Fire / Ambulance)', number: '999'),
            const _ContactRow(label: 'Fire and Rescue Dept (BOMBA)', number: '994'),
            const _ContactRow(label: 'National Disaster Mgmt Agency (NADMA)', number: '03-8064 2400'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final currentLocale = AppLocale.of(context).code;

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'settings_title'))),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          PopIn(
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.person, size: 40, color: Colors.blue.shade700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? 'Guest',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            index: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(tr(context, 'preferences'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
          ),
          FadeSlideIn(
            index: 1,
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(tr(context, 'language')),
              trailing: DropdownButton<String>(
                value: currentLocale,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ms', child: Text('Bahasa Malaysia')),
                  DropdownMenuItem(value: 'zh', child: Text('中文')),
                  DropdownMenuItem(value: 'ta', child: Text('தமிழ்')),
                ],
                onChanged: (value) {
                  if (value != null) LocaleController.setLocale(value);
                },
              ),
            ),
          ),
          FadeSlideIn(
            index: 2,
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: Text(tr(context, 'high_risk_alerts')),
              subtitle: Text(tr(context, 'high_risk_alerts_subtitle')),
              value: _notificationsEnabled,
              onChanged: _setNotifications,
            ),
          ),
          FadeSlideIn(
            index: 3,
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.mode,
              builder: (context, mode, _) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: Text(tr(context, 'dark_mode')),
                  value: mode == ThemeMode.dark,
                  onChanged: (value) => ThemeController.setDarkMode(value),
                );
              },
            ),
          ),
          const Divider(height: 32),
          FadeSlideIn(
            index: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(tr(context, 'about'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
          ),
          FadeSlideIn(
            index: 5,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(tr(context, 'about_app')),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showAboutSheet,
            ),
          ),
          FadeSlideIn(
            index: 6,
            child: ListTile(
              leading: const Icon(Icons.replay),
              title: Text(tr(context, 'replay_onboarding')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardingScreen(
                      onFinished: () => Navigator.pop(context),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 32),
          FadeSlideIn(
            index: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(tr(context, 'sign_out'), style: const TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String number;

  const _ContactRow({required this.label, required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(number, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}