import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onTryAgain;
  final VoidCallback onGoToMainMenu;
  final String tryAgainText;
  final String goToMainMenuText;

  const ActionButtons({
    Key? key,
    required this.onTryAgain,
    required this.onGoToMainMenu,
    required this.tryAgainText,
    required this.goToMainMenuText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onTryAgain,
              child: Text(tryAgainText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: onGoToMainMenu,
              child: Text(goToMainMenuText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}