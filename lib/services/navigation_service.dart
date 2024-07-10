import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../domain/entities/game_mode.dart';
import '../domain/entities/game_record.dart';
import '../presentation/screens/game_lose_screen.dart';
import '../presentation/screens/game_screen.dart';
import '../presentation/screens/game_setup_screen.dart';
import '../presentation/screens/game_win_screen.dart';
import '../presentation/screens/profile_screen.dart';
import 'fire_db_auth_service.dart';
import 'fire_db_service.dart';
import 'language_notifier.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GameMode? _currentGameMode;

  final IFireDBService fireDBService;
  final IFirebaseAuthService firebaseAuthService;
  final LanguageNotifier languageNotifier;

  NavigationService({
    required this.fireDBService,
    required this.firebaseAuthService,
    required this.languageNotifier,
  });

  void setCurrentGameMode(GameMode mode) {
    _currentGameMode = mode;
  }

  void navigateToGameSetup(BuildContext context, [GameMode? gameMode]) {
    final languageCode = languageNotifier.currentLanguageCode;
    final modeToUse = gameMode ?? _currentGameMode;
    if (modeToUse != null) {
      _currentGameMode = modeToUse;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameSetupScreen(
            gameMode: modeToUse,
            startTitle: AppStrings.getTranslatedString('eye', languageCode), // Placeholder, adjust as necessary
            goalTitle: AppStrings.getTranslatedString('europe', languageCode), // Placeholder, adjust as necessary
          ),
        ),
      );
    } else {
      // Handle the case where no game mode is available (e.g., show an error or prompt the user)
    }
  }

  void navigateToGame(BuildContext context, GameMode mode, String startTitle, String goalTitle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(
          gameMode: mode,
          startConcept: startTitle,
          goalConcept: goalTitle,
        ),
      ),
    );
  }

  Future<void> navigateToEndGame(BuildContext context, bool hasWon, String startConcept, String goalConcept, List<String> conceptsHistory, GameMode gameMode, int steps) async {
    final languageCode = languageNotifier.currentLanguageCode;
    if (hasWon) {
      User? user = firebaseAuthService.getCurrentUser();
      String recordHolder = user?.email ?? 'anonymous';
      GameRecord record = GameRecord(
        startConcept: startConcept,
        goalConcept: goalConcept,
        path: conceptsHistory,
        steps: steps,
        gameMode: gameMode,
        recordHolder: recordHolder,
      );

      String resultText;
      SaveRecordResult result = await fireDBService.saveGameRecord(record);

      switch (result) {
        case SaveRecordResult.noNewRecord:
          resultText = '${AppStrings.getTranslatedString('youFound', languageCode)} $goalConcept ${AppStrings.getTranslatedString('inSteps', languageCode)} $steps ${AppStrings.getTranslatedString('steps', languageCode)}.';
          break;
        case SaveRecordResult.newRecord:
          resultText = AppStrings.getTranslatedString('newRecord', languageCode);
          break;
        case SaveRecordResult.previousRecordBeaten:
          resultText = AppStrings.getTranslatedString('previousRecordBeaten', languageCode);
          break;
        default:
          resultText = AppStrings.getTranslatedString('congratulations', languageCode);
          break;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => GameWinScreen(
            pathText: conceptsHistory.join(" -> "),
            onGoToMainMenu: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            onTryAgain: () {
              navigateToGameSetup(context);
            },
            resultText: resultText,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameLoseScreen(
            goalConcept: goalConcept,
            pathText: conceptsHistory.join("->"),
            onGoToMainMenu: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            onTryAgain: () {
              navigateToGameSetup(context);
            },
          ),
        ),
      );
    }
  }

  void navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(languageNotifier: languageNotifier),
      ),
    );
  }

  void navigateToRankings() {
    // Handle navigation to the Rankings screen
  }
}