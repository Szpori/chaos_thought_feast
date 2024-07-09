import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle, AssetBundle;

class LocalDataService {
  List<dynamic> _articles = [];
  Map<String, List<String>> _categories = {};
  Map<String, String> _categoryMapping = {};
  final AssetBundle bundle;

  LocalDataService({AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  Future<void> loadArticles(String languageCode) async {
    String filePath = languageCode == 'pl'
        ? 'assets/data/mostPopularPagesWithCategoriesPL.json'
        : 'assets/data/mostPopularPagesWithCategories.json';

    final String response = await bundle.loadString(filePath);
    _articles = json.decode(response);
  }

  Future<void> loadCategories(String languageCode) async {
    String filePath = languageCode == 'pl'
        ? 'assets/data/categoriesPL.json'
        : 'assets/data/categories.json';

    final String response = await bundle.loadString(filePath);
    _categories = Map<String, List<String>>.from(json.decode(response).map(
            (k, v) => MapEntry<String, List<String>>(k, List<String>.from(v))));

    if (languageCode == 'pl') {
      await _loadCategoryMapping();
    }
  }

  Future<void> _loadCategoryMapping() async {
    final String response = await bundle.loadString('assets/data/categoryMapping.json');
    _categoryMapping = Map<String, String>.from(json.decode(response));
  }

  Map<String, List<String>> getCategories() {
    return _categories;
  }

  Future<String?> getRandomArticleFromCategory(String category) async {
    String mappedCategory = _categoryMapping[category] ?? category;
    List<dynamic> filteredArticles = _articles.where((article) => article['category'] == mappedCategory).toList();

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