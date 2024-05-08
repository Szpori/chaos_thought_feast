import 'dart:math';

import 'package:chaos_thought_feast/domain/entities/game_mode.dart';
import 'package:chaos_thought_feast/utils/StringUtils.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../services/navigation_service.dart';
import '../../services/wiki_service.dart';
import '../../services/finding_paths_service.dart';

class GameScreen extends StatefulWidget {
  final String startConcept;
  final String goalConcept;
  final GameMode gameMode;

  GameScreen({
    Key? key,
    required this.startConcept,
    required this.goalConcept,
    required this.gameMode,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late String currentTitle;
  String articleDescription = "";
  int? _expandedIndex;
  List<String> conceptsHistory = [];
  late List<String> options;
  late Map<String, int> goodOptions;
  List<String> pathDescriptions = [];
  late List<String> goalTitleKeywords;

  late ItemScrollController _scrollController;
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final FindingPathsService findingPathsService = FindingPathsService();
  WikiService wikiService = WikiService();
  int minPathLength = 0;
  int maxPathLength = 0;
  int? firstGoodOptionIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
    currentTitle = widget.startConcept;
    conceptsHistory.add(currentTitle);
    options = [];
    goodOptions = {};
    _fetchOptions((currentTitle));
    findingPathsService.init();
    //_fetchKeywords(currentTitle);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchOptions(String title) async {
    try {
      var fetchedOptions = await wikiService.fetchTitlesFromWikipedia(title);
      if (mounted) {
        setState(() {
          options = fetchedOptions ?? [];
          _expandedIndex = null;
          articleDescription = "";
        });

        // Schedule the scroll after the UI has updated
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (options.isNotEmpty) {
            _scrollController.scrollTo(
                index: 0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut
            );
          }
        });
      }
    } catch (e) {
      print('Error fetching options: $e');
    }
  }

  /*
  void _fetchKeywords(String title) async {
    var fetchedKeywords = await WikiService().fetchKeywords(title);
    if (mounted) {
      setState(() {
        goalTitleKeywords = fetchedKeywords;
        _expandedIndex = null;
        articleDescription = "";
      });
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

   */

  void _showArticleDescriptionDialog(String title) async {
    var description = await WikiService().fetchIntroText(title);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              description,
              style: TextStyle(fontSize: 16),
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

  void _findAndHighlightPaths() async {
    goodOptions.clear();
    pathDescriptions.clear();  // Clear previous paths
    firstGoodOptionIndex = null;

    int minPathLength = 100;
    int maxPathLength = 0;

    List<List<Path>> paths = await findingPathsService.findPaths(
        StringUtils.spaceToUnderScore(currentTitle),
        StringUtils.spaceToUnderScore(widget.goalConcept),
        3, 15
    );

    for (var path in paths) {
      Path startingNode = path[1];
      String titleWithSpaces = StringUtils.underscoreToSpace(startingNode.title);

      if (!goodOptions.containsKey(titleWithSpaces) || goodOptions[titleWithSpaces]! > path.length) {
        goodOptions[titleWithSpaces] = path.length;
        minPathLength = min(minPathLength, path.length);
        maxPathLength = max(maxPathLength, path.length);
        if (firstGoodOptionIndex == null) {
          int currentIndex = options.indexOf(titleWithSpaces);
          if (currentIndex != -1) {
            firstGoodOptionIndex = currentIndex;
          }
        }
      }

      // Build a readable path description
      String pathDescription = path.map((node) => StringUtils.underscoreToSpace(node.title)).join(" -> ");
      pathDescriptions.add(pathDescription);
      print(pathDescription);
    }

    if (mounted) {
      setState(() {
        this.minPathLength = minPathLength;
        this.maxPathLength = maxPathLength;
      });

      if (firstGoodOptionIndex != null) {
        _scrollToFirstGoodOption();
      }
    }
  }

  void _showPathDescriptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Found Paths'),
          content: SingleChildScrollView(
            child: ListBody(
              children: pathDescriptions.map((description) => Text(description)).toList(),
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

  void _scrollToFirstGoodOption() {
    if (firstGoodOptionIndex != null && firstGoodOptionIndex! >= 0 && firstGoodOptionIndex! < options.length) {
      _scrollController.scrollTo(
          index: firstGoodOptionIndex!,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut
      );
    }
  }

  void _checkForWin(String selectedTitle) {
    currentTitle = selectedTitle;
    conceptsHistory.add(currentTitle);

    if (selectedTitle.replaceAll('_', ' ') == widget.goalConcept.replaceAll('_', ' ')) {
      int steps = conceptsHistory.length;
      navigationService.navigateToEndGame(context, true, widget.startConcept, widget.goalConcept, conceptsHistory, widget.gameMode, steps);
    } else {
      setState(() {
        _fetchOptions((currentTitle));
      });
    }
  }

  void _goBack() {
    if (conceptsHistory.length > 1) {
      conceptsHistory.removeLast();
      String previousTitle = conceptsHistory.last;
      setState(() {
        currentTitle = previousTitle;
        _fetchOptions((currentTitle));
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    NavigationService navigationService = NavigationService();

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Current: $currentTitle',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Positioned(
                      left: 0,
                      child: IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
                        onPressed: () => _showArticleDescriptionDialog((currentTitle)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.info_outline_sharp, color: Colors.green),
                        onPressed: _showPathDescriptionsDialog,  // Triggers the path processing function
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Goal: ${widget.goalConcept}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Positioned(
                      left: 0,
                      child: IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.green),
                        onPressed: () => _showArticleDescriptionDialog(widget.goalConcept),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.green),
                        onPressed: _findAndHighlightPaths,  // Triggers the path processing function
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemCount: options.length,
              itemScrollController: _scrollController,
              itemBuilder: (context, index) {
                bool isGoodOption = goodOptions.containsKey(options[index]);
                bool isExpanded = index == _expandedIndex;

                int pathLength = goodOptions[options[index]] ?? (maxPathLength + 1); // Use a default that is outside the max range
                double range = maxPathLength - minPathLength.toDouble(); // Compute the range of path lengths
                double normalizedLength = range > 0 ? (pathLength - minPathLength) / range : 0; // Normalize the path length
                double saturation = max(0.3, 1.0 - normalizedLength); // Adjust saturation from 0.3 to 1.0

                Color color = HSVColor.fromAHSV(1.0, 120, saturation, 0.5).toColor();

                return Card(
                  color: isGoodOption ? color : Colors.white, // Use dynamic color based on path length
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () => _checkForWin(options[index]),
                    onLongPress: () {
                      setState(() {
                        if (index == _expandedIndex) {
                          _expandedIndex = null;
                          articleDescription = "";
                        } else {
                          _expandedIndex = index;
                          articleDescription = "Loading...";
                        }
                      });

                      WikiService().fetchIntroText(options[index]).then((description) {
                        if (mounted) {
                          setState(() {
                            if (index == _expandedIndex) {
                              articleDescription = description;
                            }
                          });
                        }
                      }).catchError((error) {
                        if (mounted) {
                          setState(() {
                            articleDescription = "Error loading description.";
                          });
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            options[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          if (isExpanded) ...[
                            SizedBox(height: 8),
                            Text(
                              articleDescription,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigationService.navigateToEndGame(
                      context,
                      false,
                      widget.goalConcept,
                      widget.startConcept, conceptsHistory,
                      widget.gameMode,
                      conceptsHistory.length
                    );
                  },
                  child: Text('End Game'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                ),
                ElevatedButton(
                  onPressed: _goBack,
                  child: Text('Go Back'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}