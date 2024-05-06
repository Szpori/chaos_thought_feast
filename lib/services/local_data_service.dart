import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/services.dart' show rootBundle;

class Node {
  final String id;
  final String name;
  final List<Node> path;

  Node(this.id, this.name, this.path);
}

class LocalDataService {
  Map<String, dynamic> _categories = {};
  Map<String, dynamic> _links = {};

  static final LocalDataService _instance = LocalDataService._internal();
  factory LocalDataService() => _instance;

  bool _isInitialized = false;
  Future<void>? _initialization;

  LocalDataService._internal();

  Future<void> init() async {
    if (!_isInitialized) {
      _initialization ??= _loadData();
      await _initialization;
      _isInitialized = true;
      _initialization = null; // Clear initialization task if needed
    }
  }

  Future<void> _loadData() async {
    // Load categories
    var categoryData = await rootBundle
        .loadString('assets/data/mostPopularPagesWithCategories.json');
    _categories = Map.fromIterable(json.decode(categoryData),
        key: (item) => item['id'], value: (item) => item);

    // Load links
    var linkData = await rootBundle.loadString('assets/data/pagesLinks.json');
    _links = {};
    for (var link in json.decode(linkData)) {
      _links[link['id']] = link;
    }
  }

  Future<void> printData() async {
    await LocalDataService().init();
    print("Categories loaded:");
    _categories.keys.take(5).forEach((key) {
      print(
          'ID: $key, Title: ${_categories[key]["title"]}, Category: ${_categories[key]["category"]}');
    });

    print("Links loaded:");
    _links.keys.take(5).forEach((key) {
      print(
          'ID: $key, Outgoing Links Count: ${_links[key]["outgoing_links_count"]}, Incoming Links Count: ${_links[key]["incoming_links_count"]}');
      print(
          'First 5 Outgoing Links: ${_links[key]["outgoing_links"].split('|').take(5).join(", ")}');
      print(
          'First 5 Incoming Links: ${_links[key]["incoming_links"].split('|').take(5).join(", ")}');
    });
  }

  Future<String> getIdByName(String title) async {
    await LocalDataService().init();
    return _categories.values.firstWhere(
        (v) => v['title'].toString().toLowerCase() == title.toLowerCase(),
        orElse: () => {'id': 'Unknown'})['id'];
  }

  String getTitleById(String id) {
    return _categories[id]?['title'] ?? 'Unknown';
  }

  Future<List<List<Node>>> findPathsFromIds(List<String> startIds,
      String goalName, int maxPaths, int maxLength) async {
    await LocalDataService().init();
    String goalId = await getIdByName(goalName);

    if (goalId == 'Unknown') {
      print("Invalid goal ID");
      return [];
    }

    List<List<Node>> foundPaths = [];
    Queue<List<Node>> queue = Queue<List<Node>>();
    Set<String> visited = Set<String>();
    Set<String> completedStartIds = Set<String>(); // Track start IDs that have found paths

    // Initialize the queue with nodes for each start ID
    for (var startId in startIds) {
      if (startId != 'Unknown') {
        String startTitle = getTitleById(startId);
        queue.add([Node(startId, startTitle, [])]);
      }
    }

    while (queue.isNotEmpty && foundPaths.length < maxPaths) {
      List<Node> currentPath = queue.removeFirst();
      Node current = currentPath.last;

      // Check if this path's start ID has already completed its search
      if (completedStartIds.contains(currentPath.first.id)) {
        continue; // Skip this path if its start ID has already found a path
      }

      if (current.id == goalId) {
        foundPaths.add(currentPath);
        completedStartIds.add(currentPath.first.id); // Mark this start ID as completed
        continue; // Continue searching for more paths
      }

      if (currentPath.length > maxLength) {
        break; // Stop searching if the next path length exceeds the limit
      }

      visited.add(current.id);

      var linkInfo = _links[current.id];
      if (linkInfo != null && linkInfo.containsKey('outgoing_links')) {
        List<String> links = linkInfo['outgoing_links'].split('|');
        for (var linkId in links) {
          if (!visited.contains(linkId)) {
            String linkTitle = getTitleById(linkId);
            List<Node> newPath = List<Node>.from(currentPath)
              ..add(Node(linkId, linkTitle, []));
            queue.add(newPath);
          }
        }
      }
    }

    return foundPaths;
  }

  Future<List<List<Node>>> findPaths(
      String startName, String goalName, int maxPaths, int maxLength) async {
    await init();
    String startId = await getIdByName(startName);
    String goalId = await getIdByName(goalName);

    if (startId == 'Unknown' || goalId == 'Unknown') {
      print("Invalid start or goal ID");
      return [];
    }

    List<List<Node>> foundPaths = [];
    Queue<List<Node>> queue = Queue<List<Node>>();
    Set<String> visited = Set<String>();

    queue.add([Node(startId, startName, [])]);

    while (queue.isNotEmpty && foundPaths.length < maxPaths) {
      List<Node> currentPath = queue.removeFirst();
      Node current = currentPath.last;

      if (current.id == goalId) {
        foundPaths.add(currentPath);
        continue; // Continue searching for more paths
      }

      if (currentPath.length > maxLength) {
        break; // Stop searching if the next path length exceeds the limit
      }

      visited.add(current.id);

      var linkInfo = _links[current.id];
      if (linkInfo != null && linkInfo.containsKey('outgoing_links')) {
        List<String> links = linkInfo['outgoing_links'].split('|');
        for (var linkId in links) {
          if (!visited.contains(linkId)) {
            String linkTitle = getTitleById(linkId);
            List<Node> newPath = List<Node>.from(currentPath)
              ..add(Node(linkId, linkTitle, []));
            queue.add(newPath);
          }
        }
      }
    }

    return foundPaths;
  }

  Future<List<Node>> findPath(String startName, String goalName) async {
    await init();
    String startId = await getIdByName(startName);
    String goalId = await getIdByName(goalName);

    if (startId == 'Unknown' || goalId == 'Unknown') {
      print("Invalid start or goal ID");
      return [];
    }

    Queue<Node> queue = Queue<Node>();
    Set<String> visited = Set<String>();

    queue.add(Node(startId, startName, []));

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();

      if (current.id == goalId) {
        current.path.add(current);
        return current.path;
      }

      visited.add(current.id);

      var linkInfo = _links[current.id];
      if (linkInfo != null && linkInfo.containsKey('outgoing_links')) {
        List<String> links = linkInfo['outgoing_links'].split('|');
        for (var linkId in links) {
          if (!visited.contains(linkId)) {
            String linkTitle = getTitleById(linkId);
            Node newNode = Node(
                linkId, linkTitle, List<Node>.from(current.path)..add(current));
            queue.add(newNode);
          }
        }
      }
    }

    print("No path found");
    return [];
  }
}
