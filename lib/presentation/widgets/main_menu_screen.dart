import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/asset_paths.dart';
import '../../constants/strings.dart';
import '../../services/language_manager.dart';

@immutable
class MainMenuScreen extends StatefulWidget {
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
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String _language = LanguageManager.defaultLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final language = await LanguageManager.getLanguage();
    setState(() {
      _language = language;
    });
  }

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
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppStrings.getTranslatedString('chaosThoughtFeast', _language),
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
                      onPressed: widget.onFindLikingsClicked,
                      child: Text(AppStrings.getTranslatedString('findYourLikings', _language)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.onLikingSpectrumJourneyClicked,
                      child: Text(AppStrings.getTranslatedString('likingSpectrumJourney', _language)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.onAnyfinCanHappenClicked,
                      child: Text(AppStrings.getTranslatedString('anyfinCanHappen', _language)),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: widget.onProfileClicked,
                child: Text(AppStrings.getTranslatedString('profile', _language)),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }
}