import 'package:flutter/material.dart';
import '../widgets/main_menu_screen.dart';
import '../../domain/entities/game_mode.dart';
import '../../services/navigation_service.dart';

class MainMenuActivity extends StatelessWidget {
  final NavigationService navigationService;

  MainMenuActivity({Key? key, required this.navigationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainMenuScreen(
        onFindLikingsClicked: () => navigationService.navigateToGameSetup(context, GameMode.findYourLikings),
        onLikingSpectrumJourneyClicked: () => navigationService.navigateToGameSetup(context, GameMode.likingSpectrumJourney),
        onAnyfinCanHappenClicked: () => navigationService.navigateToGameSetup(context, GameMode.anyfinCanHappen),
        onProfileClicked: () {
          navigationService.navigateToProfile(context);
        },
        onRankingsClicked: navigationService.navigateToRankings,
      ),
    );
  }

}