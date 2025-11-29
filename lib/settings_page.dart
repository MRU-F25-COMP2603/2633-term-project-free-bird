import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'theme_provider.dart';
import 'text_scale_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  String _language = "English";

  bool _ttsEnabled = false;
  final FlutterTts tts = FlutterTts();

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // ---------------------------------------------------------
  // LOAD / SAVE PREFERENCES
  // ---------------------------------------------------------
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ttsEnabled = prefs.getBool('ttsEnabled') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
      _language = prefs.getString('language') ?? "English";
    });
  }

  Future<void> _updateNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() => _notifications = value);
  }

  Future<void> _updateLanguage(String? value) async {
    if (value == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    setState(() => _language = value);
  }

  Future<void> _updateTtsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ttsEnabled', value);
    setState(() => _ttsEnabled = value);
  }

  // ---------------------------------------------------------
  // TEXT-TO-SPEECH FUNCTION
  // ---------------------------------------------------------
  Future<void> speak(String text) async {
    if (!_ttsEnabled) return;

    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  // ---------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final textScale = Provider.of<TextScaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------------------------------------------------------
          // USER INFO CARD
          // ---------------------------------------------------------
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? "User",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? "No email",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // DARK MODE TOGGLE
          // ---------------------------------------------------------
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: context.watch<ThemeProvider>().isDarkMode,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
            secondary: const Icon(Icons.dark_mode),
          ),

          // ---------------------------------------------------------
          // TEXT SIZE / MAGNIFICATION
          // ---------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text("Text Size"),
            subtitle: Slider(
              value: textScale.scale,
              min: 0.8,
              max: 1.6,
              divisions: 8,
              label: textScale.scale.toStringAsFixed(1),
              onChanged: (value) => textScale.setScale(value),
            ),
          ),

          // ---------------------------------------------------------
          // TEXT-TO-SPEECH TOGGLE
          // ---------------------------------------------------------
          SwitchListTile(
            title: const Text("Text-to-Speech"),
            value: _ttsEnabled,
            onChanged: _updateTtsEnabled,
            secondary: const Icon(Icons.record_voice_over),
          ),

          // SPEAK SCREEN BUTTON
          if (_ttsEnabled)
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text("Speak Screen"),
              onTap: () {
                speak(
                  "Settings. Dark mode. Text size. Text to speech. "
                  "Language. Notifications. "
                  "About this app. Version 1.0. FreeBird Travel Companion App.",
                );
              },
            ),

          const SizedBox(height: 12),

          // ---------------------------------------------------------
          // LANGUAGE DROPDOWN
          // ---------------------------------------------------------
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
                DropdownMenuItem(value: "French", child: Text("French")),
                DropdownMenuItem(value: "Spanish", child: Text("Spanish")),
              ],
              onChanged: _updateLanguage,
            ),
          ),

          // ---------------------------------------------------------
          // NOTIFICATIONS TOGGLE
          // ---------------------------------------------------------
          SwitchListTile(
            title: const Text("Notifications"),
            value: _notifications,
            onChanged: _updateNotifications,
            secondary: const Icon(Icons.notifications),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // ABOUT SECTION
          // ---------------------------------------------------------
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About This App",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Version: ", style: TextStyle(fontSize: 16)),
                      Text(
                        "1.0.0",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "FreeBird Travel Companion App\n"
                    "Created as a COMP 2633 Final Project.\n"
                    "Features: Document Storage, Camera Uploads, Translation, Flight Tracking, and Hotel Bookings.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // LOGOUT BUTTON
          // ---------------------------------------------------------
          ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Log Out",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
