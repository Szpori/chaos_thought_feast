import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart' show rootBundle;

class Path {
  final String title;
  final List<Path> path;

  Path(this.title, this.path);
}

class FindingPathsService {
  Map<String, List<String>> outgoingLinks = {};
  Map<String, List<String>> incomingLinks = {};

  static final FindingPathsService _instance = FindingPathsService._internal();
  factory FindingPathsService() => _instance;

  bool _isInitialized = false;
  Future<void>? _initialization;

  FindingPathsService._internal();

  Future<void> init() async {
    if (!_isInitialized) {
      _initialization ??= _loadData();
      await _initialization;
      _isInitialized = true;
      _initialization = null;
    }
  }

  Future<void> _loadData() async {
    var data = await rootBundle.loadString('assets/data/mergedOutput4.json');
    List<dynamic> jsonData;
    try {
      jsonData = json.decode(data);
    } catch (e) {
      print("Failed to decode JSON file: $e");
      return; // Early exit if JSON parsing fails
    }

    for (var item in jsonData) {
      // Ensure item contains 'title' before proceeding
      if (item['title'] != null) {
        // Use List<String>.from with empty list as default to handle null incoming/outgoing links
        outgoingLinks[item['title']] = List<String>.from(item['outgoing_links'] ?? []);
        incomingLinks[item['title']] = List<String>.from(item['incoming_links'] ?? []);
      } else {
        print("Item missing 'title': $item");
      }
    }
  }

  void _expandQueue(PriorityQueue<List<Path>> queue, Map<String, List<Path>> visited, Map<String, List<String>> links, String targetTitle, int maxLength, {bool reverse = false}) {
    if (queue.isEmpty) return;
    List<Path> currentPath = queue.removeFirst();
    Path currentNode = currentPath.last;

    if (currentPath.length > maxLength) {
      print("Path exceeded maximum length: ${currentPath.length}");
      return;
    }

    visited[currentNode.title] = currentPath;
    var currentLinks = links[currentNode.title]?.toList() ?? [];

    for (String link in currentLinks) {
      if (!visited.containsKey(link)) {
        List<Path> newPath = List<Path>.from(currentPath)..add(Path(link, []));
        queue.add(newPath);
      } else {
      }
    }
  }

  Future<List<List<Path>>> findPaths(String startTitle, String goalTitle, int maxPaths, int maxLength) async {
    await init();

    print("Starting title: $startTitle with links: ${outgoingLinks[(startTitle)]}");
    print("Goal title: $goalTitle with links: ${incomingLinks[(goalTitle)]}");

    var forwardQueue = PriorityQueue<List<Path>>((a, b) => a.length.compareTo(b.length));
    var backwardQueue = PriorityQueue<List<Path>>((a, b) => a.length.compareTo(b.length));
    Map<String, List<Path>> visitedForward = {};
    Map<String, List<Path>> visitedBackward = {};

    forwardQueue.add([Path((startTitle), [])]);
    backwardQueue.add([Path((goalTitle), [])]);
    List<List<Path>> foundPaths = [];

    bool containsPath(List<Path> newPath) {
      var equality = const ListEquality();
      return foundPaths.any((existingPath) => equality.equals(
          existingPath.map((p) => p.title).toList(),
          newPath.map((p) => p.title).toList()
      ));
    }

    void addPathIfUnique(List<Path> newPath) {
      if (!containsPath(newPath)) {
        foundPaths.add(newPath);
      }
    }


    while (forwardQueue.isNotEmpty && backwardQueue.isNotEmpty && foundPaths.length < maxPaths) {
      if (forwardQueue.isNotEmpty) {
        _expandQueue(forwardQueue, visitedForward, outgoingLinks, goalTitle, maxLength, reverse: false);
      }
      if (backwardQueue.isNotEmpty) {
        _expandQueue(backwardQueue, visitedBackward, incomingLinks, startTitle, maxLength, reverse: true);
      }

      String? meetingPoint = _findMeetingPoint(visitedForward, visitedBackward);
      if (meetingPoint != null) {
        List<Path> newPath = _connectPaths(visitedForward[meetingPoint]!, visitedBackward[meetingPoint]!);
        addPathIfUnique(newPath);
        if (foundPaths.length >= maxPaths) break;
      }
    }

    return foundPaths;
  }

  String? _findMeetingPoint(Map<String, List<Path>> visitedForward, Map<String, List<Path>> visitedBackward) {
    Set<String> keysForward = visitedForward.keys.toSet();
    Set<String> keysBackward = visitedBackward.keys.toSet();
    return keysForward.intersection(keysBackward).firstWhereOrNull((key) => true);
  }

  List<Path> _connectPaths(List<Path> pathFromStart, List<Path> pathFromGoal) {
    // Reverse the path from the goal to align it with the direction of the start path
    List<Path> reversedPathFromGoal = List<Path>.from(pathFromGoal.reversed);

    // Remove the first element of the reversed path to avoid duplicating the meeting point
    if (reversedPathFromGoal.isNotEmpty) reversedPathFromGoal.removeAt(0);

    // Combine the two paths
    List<Path> fullPath = List<Path>.from(pathFromStart)..addAll(reversedPathFromGoal);

    // Wrap the result in a list of list of paths for consistency with the expected return type
    return fullPath;
  }

}