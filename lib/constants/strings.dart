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
    }
  };

  static String getTranslatedString(String key, String language) {
    return translations[language]?[key] ?? translations[defaultLanguage]![key] ?? key;
  }
}