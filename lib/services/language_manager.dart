import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static const String _languageKey = 'language';
  static const String defaultLanguage = 'eng';

  static Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? defaultLanguage;
  }
}