import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/StringUtils.dart';

class LanguageNotifier extends ValueNotifier<String> {
  LanguageNotifier() : super('eng') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language');
    if (languageCode == null) {
      languageCode = 'eng';
      await prefs.setString('language', languageCode);
    }
    value = StringUtils.reverseLanguageMap[languageCode]!;
  }

  Future<void> setLanguage(String language) async {
    value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', StringUtils.languageMap[language]!);
  }
}