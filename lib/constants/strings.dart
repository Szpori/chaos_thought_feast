class AppStrings {
  static const chaosThoughtFeast = 'Chaos Thought Feast';
  static const findYourLikings = 'Find Your Likings';
  static const likingSpectrumJourney = 'Liking Spectrum Journey';
  static const anyfinCanHappen = 'Anyfin Can Happen';
  static const profile = 'Profile';

  static const chaosThoughtFeastPl = 'Chaotyczna Uczta Myśli';
  static const findYourLikingsPl = 'Znajdź Swoje Upodobania';
  static const likingSpectrumJourneyPl = 'Podróż przez Spektrum Upodobań';
  static const anyfinCanHappenPl = 'Wszystko może się Zdarzyć';
  static const profilePl = 'Profil';

  static const selectCategory = 'Select a category';
  static const startingConcept = 'Starting Concept';
  static const goalConcept = 'Goal Concept';
  static const startGame = 'Start Game';

  static const selectCategoryPl = 'Wybierz kategorię';
  static const startingConceptPl = 'Pojęcie początkowe';
  static const goalConceptPl = 'Pojęcie końcowe';
  static const startGamePl = 'Rozpocznij grę';

  static String getTranslatedString(String key, String language) {
    switch (key) {
      case 'chaosThoughtFeast':
        return language == 'pl' ? chaosThoughtFeastPl : chaosThoughtFeast;
      case 'findYourLikings':
        return language == 'pl' ? findYourLikingsPl : findYourLikings;
      case 'likingSpectrumJourney':
        return language == 'pl' ? likingSpectrumJourneyPl : likingSpectrumJourney;
      case 'anyfinCanHappen':
        return language == 'pl' ? anyfinCanHappenPl : anyfinCanHappen;
      case 'profile':
        return language == 'pl' ? profilePl : profile;
      case 'selectCategory':
        return language == 'pl' ? selectCategoryPl : selectCategory;
      case 'startingConcept':
        return language == 'pl' ? startingConceptPl : startingConcept;
      case 'goalConcept':
        return language == 'pl' ? goalConceptPl : goalConcept;
      case 'startGame':
        return language == 'pl' ? startGamePl : startGame;
      default:
        return key;
    }
  }
}