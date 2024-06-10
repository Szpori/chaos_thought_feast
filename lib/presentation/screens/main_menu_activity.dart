import 'package:flutter/material.dart';
import '../../services/language_notifier.dart';
import '../widgets/main_menu_screen.dart';
import '../../domain/entities/game_mode.dart';
import '../../services/navigation_service.dart';

class MainMenuActivity extends StatelessWidget {
  final NavigationService navigationService;
  final LanguageNotifier languageNotifier;

  MainMenuActivity({
    Key? key,
    required this.navigationService,
    required this.languageNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainMenuScreen(
        languageNotifier: languageNotifier,
        onFindLikingsClicked: () => navigationService.navigateToGameSetup(context, GameMode.findYourLikings),
        onLikingSpectrumJourneyClicked: () => navigationService.navigateToGameSetup(context, GameMode.likingSpectrumJourney),
        onAnyfinCanHappenClicked: () => navigationService.navigateToGameSetup(context, GameMode.anyfinCanHappen),
        onProfileClicked: () {
          print("LANG");
          print(languageNotifier.value);
          navigationService.navigateToProfile(context);
        },
        onRankingsClicked: () {
          // Update this method if needed to pass the correct context
          navigationService.navigateToRankings();
        },
      ),
    );
  }
}