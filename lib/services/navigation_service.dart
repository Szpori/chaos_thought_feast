import 'package:chaos_thought_feast/services/wiki_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../domain/entities/game_mode.dart';
import '../domain/entities/game_record.dart';
import '../presentation/screens/game_lose_screen.dart';
import '../presentation/screens/game_screen.dart';
import '../presentation/screens/game_setup_screen.dart';
import '../presentation/screens/game_win_screen.dart';
import '../presentation/screens/profile_screen.dart';
import 'fire_db_auth_service.dart';
import 'fire_db_service.dart';


class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GameMode? _currentGameMode;

  final IFireDBService fireDBService;
  final IFirebaseAuthService firebaseAuthService;

  NavigationService._internal({
    required this.fireDBService,
    required this.firebaseAuthService,
  });

  // Named constructor for testing purposes
  NavigationService.testConstructor({
    required this.fireDBService,
    required this.firebaseAuthService,
  });

  static final NavigationService _instance = NavigationService._internal(
    fireDBService: RealFireDBService(),
    firebaseAuthService: AuthService(),
  );

  factory NavigationService() {
    return _instance;
  }

  void setCurrentGameMode(GameMode mode) {
    _currentGameMode = mode;
  }

  void navigateToGameSetup(BuildContext context, [GameMode? gameMode]) {
    final modeToUse = gameMode ?? _currentGameMode;
    if (modeToUse != null) {
      _currentGameMode = modeToUse;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameSetupScreen(
            gameMode: modeToUse,
            startTitle: 'County Dublin', // Placeholder, adjust as necessary
            goalTitle: 'Europe', // Placeholder, adjust as necessary
          ),
        ),
      );
    } else {
      // Handle the case where no game mode is available (e.g., show an error or prompt the user)
    }
  }

  void navigateToGame(BuildContext context, GameMode mode, String startTitle, String goalTitle) {
    Navigator.push(
      context,
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
          resultText = 'You found $goalConcept in $steps steps.';
          break;
        case SaveRecordResult.newRecord:
          resultText = 'This path has remained unexplored until now! You\'ve set a new record in its discovery.';
          break;
        case SaveRecordResult.previousRecordBeaten:
          resultText = 'You\'ve discovered a shorter path linking both concepts! You surpassed the previous record.';
          break;
        default:
          resultText = 'Congratulations on your win!';
          break;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameWinScreen(
            goalConcept: goalConcept,
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
      Navigator.push(
        context,
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
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  void navigateToRankings() {
    // Handle navigation to the Rankings screen
  }
}

// Global instance
final navigationService = NavigationService();