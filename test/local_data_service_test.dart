import 'dart:convert';

import 'package:chaos_thought_feast/services/local_data_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalDataService localDataService;
  late MockAssetBundle mockAssetBundle;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    localDataService = LocalDataService(bundle: mockAssetBundle);
  });

  group('LocalDataService', () {
    test('loadArticles should correctly load articles from JSON', () async {
      final articlesJson = jsonEncode([
        {'title': 'Article 1', 'category': 'Category 1'},
        {'title': 'Article 2', 'category': 'Category 2'}
      ]);

      when(() => mockAssetBundle.loadString('assets/data/mostPopularPagesWithCategories.json'))
          .thenAnswer((_) async => articlesJson);

      await localDataService.loadArticles();

      expect(await localDataService.getRandomArticle(), isNotNull);
    });

    test('loadCategories should correctly load categories from JSON', () async {
      final categoriesJson = jsonEncode({
        'Category 1': ['Article 1'],
        'Category 2': ['Article 2']
      });

      when(() => mockAssetBundle.loadString('assets/data/categories.json'))
          .thenAnswer((_) async => categoriesJson);

      await localDataService.loadCategories();

      expect(localDataService.getCategories(), containsPair('Category 1', ['Article 1']));
    });

    test('getRandomArticleFromCategory should return a random article from the given category', () async {
      final articlesJson = jsonEncode([
        {'title': 'Article 1', 'category': 'Category 1'},
        {'title': 'Article 2', 'category': 'Category 1'},
        {'title': 'Article 3', 'category': 'Category 2'}
      ]);

      when(() => mockAssetBundle.loadString('assets/data/mostPopularPagesWithCategories.json'))
          .thenAnswer((_) async => articlesJson);

      await localDataService.loadArticles();
      String? articleTitle = await localDataService.getRandomArticleFromCategory('Category 1');

      expect(['Article 1', 'Article 2'], contains(articleTitle));
    });

    test('getRandomArticle should return a random article from all articles', () async {
      final articlesJson = jsonEncode([
        {'title': 'Article 1', 'category': 'Category 1'},
        {'title': 'Article 2', 'category': 'Category 2'}
      ]);

      when(() => mockAssetBundle.loadString('assets/data/mostPopularPagesWithCategories.json'))
          .thenAnswer((_) async => articlesJson);

      await localDataService.loadArticles();
      String? articleTitle = await localDataService.getRandomArticle();

      expect(['Article 1', 'Article 2'], contains(articleTitle));
    });

    group('LocalDataService with Real Data', () {
      setUp(() {
        localDataService = LocalDataService();
      });

      test('loadCategories should correctly load real categories from JSON', () async {
        await localDataService.loadCategories();
        final categories = localDataService.getCategories();

        expect(categories, isNotEmpty);
        expect(categories, contains('Technology'));
        expect(categories['Technology'], containsAll(['IT', 'Technology']));
      });
    });

  });
}