import 'package:flutter/material.dart';
import '../../constants/asset_paths.dart';
import '../../constants/strings.dart';
import '../../services/language_notifier.dart';

@immutable
class MainMenuScreen extends StatelessWidget {
  final LanguageNotifier languageNotifier;
  final VoidCallback onFindLikingsClicked;
  final VoidCallback onLikingSpectrumJourneyClicked;
  final VoidCallback onAnyfinCanHappenClicked;
  final VoidCallback onProfileClicked;
  final VoidCallback onRankingsClicked;

  const MainMenuScreen({
    Key? key,
    required this.languageNotifier,
    required this.onFindLikingsClicked,
    required this.onLikingSpectrumJourneyClicked,
    required this.onAnyfinCanHappenClicked,
    required this.onProfileClicked,
    required this.onRankingsClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<String>(
        valueListenable: languageNotifier,
        builder: (context, language, child) {
          final languageCode = languageNotifier.currentLanguageCode;
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(AssetPaths.forestPathOfKnowledge, fit: BoxFit.cover),
              ),
              Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppStrings.getTranslatedString('chaosThoughtFeast', languageCode),
                        style: const TextStyle(
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
                          child: Text(AppStrings.getTranslatedString('findYourLikings', languageCode)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: onLikingSpectrumJourneyClicked,
                          child: Text(AppStrings.getTranslatedString('likingSpectrumJourney', languageCode)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: onAnyfinCanHappenClicked,
                          child: Text(AppStrings.getTranslatedString('anyfinCanHappen', languageCode)),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  ElevatedButton(
                    onPressed: onProfileClicked,
                    child: Text(AppStrings.getTranslatedString('profile', languageCode)),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}