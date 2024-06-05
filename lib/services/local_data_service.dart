import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle, AssetBundle;

class LocalDataService {
  List<dynamic> _articles = [];
  Map<String, List<String>> _categories = {};
  final AssetBundle bundle;

  LocalDataService({AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  Future<void> loadArticles() async {
    final String response = await bundle.loadString('assets/data/mostPopularPagesWithCategories.json');
    _articles = json.decode(response);
  }

  Future<void> loadCategories() async {
    final String response = await bundle.loadString('assets/data/categories.json');
    _categories = Map<String, List<String>>.from(json.decode(response).map(
            (k, v) => MapEntry<String, List<String>>(k, List<String>.from(v))));
  }

  Map<String, List<String>> getCategories() {
    return _categories;
  }

  Future<String?> getRandomArticleFromCategory(String category) async {
    List<dynamic> filteredArticles = _articles.where((article) => article['category'] == category).toList();

    if (filteredArticles.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(filteredArticles.length);
      return filteredArticles[randomIndex]['title'];
    }
    return null;
  }

  Future<String?> getRandomArticle() async {
    if (_articles.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(_articles.length);
      return _articles[randomIndex]['title'];
    }
    return null;
  }
}