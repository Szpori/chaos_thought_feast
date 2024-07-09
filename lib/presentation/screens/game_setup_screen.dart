import 'package:chaos_thought_feast/constants/asset_paths.dart';
import 'package:chaos_thought_feast/services/local_data_service.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';
import '../../domain/entities/game_mode.dart';
import '../../locator.dart';
import '../../services/finding_paths_service.dart';
import '../../services/language_notifier.dart';
import '../../services/navigation_service.dart';
import '../../services/wiki_service.dart';
import '../widgets/category_modal_content.dart';

class GameSetupScreen extends StatefulWidget {
  final GameMode gameMode;
  final String startTitle;
  final String goalTitle;

  GameSetupScreen({
    Key? key,
    required this.gameMode,
    required this.startTitle,
    required this.goalTitle,
  }) : super(key: key);

  @override
  _GameSetupScreenState createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  late TextEditingController _startTitleController;
  late TextEditingController _goalTitleController;
  late LocalDataService _localDataService;
  late FindingPathsService _findingPathsService;

  String? _selectedCategory;
  Map<String, List<String>> _categories = {};
  Map<String, bool> _expandedCategories = {};

  bool get isStartTitleEditable => widget.gameMode == GameMode.findYourLikings;
  bool get isGoalTitleEditable => widget.gameMode != GameMode.anyfinCanHappen;

  @override
  void initState() {
    super.initState();
    _startTitleController = TextEditingController(text: widget.startTitle);
    _goalTitleController = TextEditingController(text: widget.goalTitle);
    _localDataService = LocalDataService();
    _findingPathsService = FindingPathsService();
    _initData();
  }

  Future<void> _initData() async {
    await _localDataService.loadArticles();
    await _localDataService.loadCategories();
    await _findingPathsService.init();
    _fetchCategoriesFromLocalData();
  }

  Future<void> _fetchCategoriesFromLocalData() async {
    Map<String, List<String>> categories = _localDataService.getCategories();
    setState(() {
      _categories = categories;
      _expandedCategories = Map.fromIterable(categories.keys,
          key: (item) => item, value: (item) => false);
    });
  }

  @override
  void dispose() {
    _startTitleController.dispose();
    _goalTitleController.dispose();
    super.dispose();
  }

  String getTitle(GameMode gameMode, String languageCode) {
    switch (gameMode) {
      case GameMode.findYourLikings:
        return AppStrings.getTranslatedString('findYourLikings', languageCode);
      case GameMode.likingSpectrumJourney:
        return AppStrings.getTranslatedString('likingSpectrumJourney', languageCode);
      case GameMode.anyfinCanHappen:
        return AppStrings.getTranslatedString('anyfinCanHappen', languageCode);
      default:
        return AppStrings.getTranslatedString('findYourLikings', languageCode); // Default title or consider throwing an exception if unreachable
    }
  }

  String getBackgroundImage() {
    switch (widget.gameMode) {
      case GameMode.findYourLikings:
        return AssetPaths.findYourLikings;
      case GameMode.likingSpectrumJourney:
        return AssetPaths.likingSpectrumJourney;
      case GameMode.anyfinCanHappen:
        return AssetPaths.anyfinCanHappen;
      default:
        return "assets/defaultbackground.webp";
    }
  }

  Widget _categorySelector(BuildContext context, String language) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: TextEditingController(text: _selectedCategory),
            decoration: InputDecoration(
              labelText: AppStrings.getTranslatedString('selectCategory', language),
              border: OutlineInputBorder(),
            ),
            readOnly: true,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _showCategoryModal(context),
        ),
      ],
    );
  }

  void _showCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: CategoryModalContent(
            categories: _categories,
            onSubcategorySelected: (subcategory) {
              setState(() {
                _selectedCategory = subcategory;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildTitleFieldWithRandomButton({
    required TextEditingController controller,
    required String label,
    VoidCallback? onRandomSelected,
    VoidCallback? onInfoSelected,
  }) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 2.0),
          child: IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: onInfoSelected,
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Image.asset(
            'assets/icons/shuffle_icon.png',
            width: 48.0,
            height: 48.0,
          ),
          onPressed: onRandomSelected,
        ),
      ],
    );
  }

  void showArticleInfoDialog(BuildContext context, String title) async {
    WikiService wikiService = WikiService();
    String introText = await wikiService.fetchIntroText(title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text(
              introText,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void selectRandomArticleForTitle(TextEditingController controller, bool checkOutgoingLinks) async {
    await FindingPathsService().init();

    String? randomArticleTitle;

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      randomArticleTitle = await _localDataService.getRandomArticle();
    } else {
      randomArticleTitle = await _localDataService.getRandomArticleFromCategory(_selectedCategory!);
    }

    if (checkOutgoingLinks) {
      while (randomArticleTitle != null && !FindingPathsService().hasOutgoingLinks(randomArticleTitle)) {
        randomArticleTitle = await _localDataService.getRandomArticle();
      }
    } else {
      while (randomArticleTitle != null && !FindingPathsService().hasIncomingLinks(randomArticleTitle)) {
        randomArticleTitle = await _localDataService.getRandomArticle();
      }
    }

    setState(() {
      controller.text = randomArticleTitle ?? "No article found";
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = locator<LanguageNotifier>();
    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, language, child) {
        final languageCode = languageNotifier.currentLanguageCode;
        return Scaffold(
          appBar: AppBar(
            title: Text(getTitle(widget.gameMode, languageCode)),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBackgroundImage()),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          getTitle(widget.gameMode, languageCode),
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        if (isStartTitleEditable)
                          _buildTitleFieldWithRandomButton(
                            controller: _startTitleController,
                            label: AppStrings.getTranslatedString('startingConcept', languageCode),
                            onRandomSelected: () => selectRandomArticleForTitle(_startTitleController, true),
                            onInfoSelected: () => showArticleInfoDialog(context, _startTitleController.text),
                          ),
                        SizedBox(height: 16),
                        if (isGoalTitleEditable)
                          _buildTitleFieldWithRandomButton(
                            controller: _goalTitleController,
                            label: AppStrings.getTranslatedString('goalConcept', languageCode),
                            onRandomSelected: () => selectRandomArticleForTitle(_goalTitleController, false),
                            onInfoSelected: () => showArticleInfoDialog(context, _goalTitleController.text),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            GameMode selectedMode = GameMode.findYourLikings;
                            String startTitle = _startTitleController.text;
                            String goalTitle = _goalTitleController.text;

                            locator<NavigationService>().navigateToGame(context, selectedMode, startTitle, goalTitle);
                          },
                          child: Text(AppStrings.getTranslatedString('startGame', languageCode)),
                        ),
                        const SizedBox(height: 16),
                        _categorySelector(context, languageCode),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}