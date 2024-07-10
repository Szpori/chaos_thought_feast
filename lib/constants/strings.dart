class AppStrings {
  static const String defaultLanguage = 'en';

  static const Map<String, Map<String, String>> translations = {
    'en': {
      'chaosThoughtFeast': 'Chaos Thought Feast',
      'findYourLikings': 'Find Your Likings',
      'likingSpectrumJourney': 'Liking Spectrum Journey',
      'anyfinCanHappen': 'Anyfin Can Happen',
      'profile': 'Profile',
      'selectCategory': 'Select a category',
      'startingConcept': 'Starting Concept',
      'goalConcept': 'Goal Concept',
      'startGame': 'Start Game',
      'eye': 'Eye',
      'europe': 'Europe',
      'youFound': 'You found',
      'inSteps': 'in',
      'steps': 'steps',
      'newRecord': 'This path has remained unexplored until now! You\'ve set a new record in its discovery.',
      'previousRecordBeaten': 'You\'ve discovered a shorter path linking both concepts! You surpassed the previous record.',
      'congratulations': 'Congratulations on your win!',
      'noContent': 'No content found',
    },
    'pl': {
      'chaosThoughtFeast': 'Chaotyczna Uczta Myśli',
      'findYourLikings': 'Znajdź Swoje Upodobania',
      'likingSpectrumJourney': 'Podróż przez Spektrum Upodobań',
      'anyfinCanHappen': 'Wszystko może się Zdarzyć',
      'profile': 'Profil',
      'selectCategory': 'Wybierz kategorię',
      'startingConcept': 'Pojęcie początkowe',
      'goalConcept': 'Pojęcie końcowe',
      'startGame': 'Rozpocznij grę',
      'eye': 'Oko',
      'europe': 'Europa',
      'youFound': 'Znalazłeś',
      'inSteps': 'w',
      'steps': 'krokach',
      'newRecord': 'Ta ścieżka była do tej pory nieznana! Ustanowiłeś nowy rekord w jej odkrywaniu.',
      'previousRecordBeaten': 'Odkryłeś krótszą ścieżkę łączącą oba pojęcia! Przekroczyłeś poprzedni rekord.',
      'congratulations': 'Gratulacje z wygranej!',
      'noContent': 'Brak treści',
    }
  };

  static String getTranslatedString(String key, String language) {
    return translations[language]?[key] ?? translations[defaultLanguage]![key] ?? key;
  }
}