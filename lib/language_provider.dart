import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'English';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'English';
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (_currentLanguage == language) return;
    
    _currentLanguage = language;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  /// Helper method to get translated string
  String translate(String key, Map<String, Map<String, String>> translations) {
    return translations[_currentLanguage]?[key] ?? 
           translations['English']?[key] ?? 
           key;
  }

  /// Safely get the current language without requiring a Provider ancestor.
  /// If the provider is not found in the tree (e.g., in isolated widget tests),
  /// this returns 'English' by default to keep widgets rendering.
  static String currentOrDefault(BuildContext context, {String fallback = 'English'}) {
    try {
      final provider = Provider.of<LanguageProvider>(context, listen: false);
      return provider.currentLanguage;
    } catch (_) {
      return fallback;
    }
  }
}
