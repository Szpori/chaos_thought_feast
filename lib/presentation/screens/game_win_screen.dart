import 'package:flutter/material.dart';

import '../widgets/action_buttons.dart';

class GameWinScreen extends StatelessWidget {
  final String resultText;
  final String pathText;
  final VoidCallback onGoToMainMenu;
  final VoidCallback onTryAgain;

  // Constructor for winning scenario
  GameWinScreen({
    Key? key,
    required this.resultText,
    required this.pathText,
    required this.onGoToMainMenu,
    required this.onTryAgain, required String goalConcept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/foundcorrectpathwin.webp',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildText('You connected the dots!', 25.0, FontWeight.bold),
            SizedBox(height: 8),
            _buildText('Your Wiki Path', 25.0, FontWeight.bold),
            _buildText(pathText, 20.0, FontWeight.bold),
            _buildText(resultText, 20.0, FontWeight.normal),
            Spacer(),
            ActionButtons(
              onTryAgain: onTryAgain,
              onGoToMainMenu: onGoToMainMenu,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: TextAlign.center,
    );
  }
}