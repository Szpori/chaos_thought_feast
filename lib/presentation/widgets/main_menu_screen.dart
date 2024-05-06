import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../constants/strings.dart';

@immutable
class MainMenuScreen extends StatelessWidget {
  final VoidCallback onFindLikingsClicked;
  final VoidCallback onLikingSpectrumJourneyClicked;
  final VoidCallback onAnyfinCanHappenClicked;
  final VoidCallback onProfileClicked;
  final VoidCallback onRankingsClicked;

  const MainMenuScreen({
    Key? key,
    required this.onFindLikingsClicked,
    required this.onLikingSpectrumJourneyClicked,
    required this.onAnyfinCanHappenClicked,
    required this.onProfileClicked,
    required this.onRankingsClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(AssetPaths.forestPathOfKnowledge, fit: BoxFit.cover),
          ),
          Column(
            children: [
              const Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppStrings.chaosThoughtFeast,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: onFindLikingsClicked,
                      child: const Text(AppStrings.findYourLikings),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onLikingSpectrumJourneyClicked,
                      child: const Text(AppStrings.likingSpectrumJourney),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onAnyfinCanHappenClicked,
                      child: const Text(AppStrings.anyfinCanHappen),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 2),
              ElevatedButton(
                onPressed: onProfileClicked, // Use the callback here
                child: const Text(AppStrings.profile), // The text for your button
              ),
              Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }
}