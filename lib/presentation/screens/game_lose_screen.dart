import 'package:flutter/material.dart';

import '../../constants/strings.dart';
import '../widgets/action_buttons.dart';

class GameLoseScreen extends StatelessWidget {
  final String goalConcept;
  final String pathText;
  final VoidCallback onGoToMainMenu;
  final VoidCallback onTryAgain;

  GameLoseScreen({
    Key? key,
    required this.goalConcept,
    required this.pathText,
    required this.onGoToMainMenu,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/deadendpathlose.webp', // Replace with your actual image asset for losing
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Text(
                'You failed to reach the goal!',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Text(
                'Your path was: $pathText',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Text(
                'Goal Concept was: $goalConcept',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(flex: 2),
              ActionButtons(
                onTryAgain: onTryAgain,
                onGoToMainMenu: onGoToMainMenu,
                tryAgainText: 'Try Again',
                goToMainMenuText: 'Main Menu',
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
