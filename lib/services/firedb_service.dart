import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

import '../domain/entities/game_record.dart';

enum SaveRecordResult {
  noNewRecord,
  newRecord,
  previousRecordBeaten,
}

class FireDBService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final String lang = ""; // Example language code, replace with dynamic value if needed

  Future<Map<String, List<String>>> fetchCategories() async {
    DatabaseReference categoriesRef = _database.ref('categories');
    DataSnapshot snapshot = await categoriesRef.get();

    Map<String, List<String>> categories = {};

    if (snapshot.exists) {
      Map<dynamic, dynamic> categoriesMap = snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        List<String> subcategories = List<String>.from(value as List);
        categories[key] = subcategories;
      });
    }
    return categories;
  }

  Future<String?> getRandomArticleFromCategory(String category) async {
    Query ref = _database.ref('mostPopularPagesWithCategories').orderByChild('category').equalTo(category);
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      List<dynamic> articles = [];
      Map<dynamic, dynamic> value = snapshot.value as Map<dynamic, dynamic>;
      value.forEach((key, val) {
        articles.add(val["title"]);
      });

      if (articles.isNotEmpty) {
        Random random = Random();
        int randomIndex = random.nextInt(articles.length);
        return articles[randomIndex];
      }
    }
    return null;
  }

  Future<String?> getRandomArticle() async {
    Random random = Random();
    int randomIndex = random.nextInt(30000);
    String? randomId = randomIndex.toString();

    DatabaseReference ref = _database.ref('mostPopularPagesWithCategories/$randomId');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> valueMap = Map<String, dynamic>.from(snapshot.value as Map);
        return valueMap['title'];
    } else {
        return getRandomArticle();
    }
  }

  Future<SaveRecordResult> saveGameRecord(GameRecord record) async {
    String gameModePath = record.gameMode.toString().split('.').last;
    final dbRef = FirebaseDatabase.instance.ref('gameRecords/$gameModePath/${record.startConcept}_${record.goalConcept}');
    final snapshot = await dbRef.get();

    if (snapshot.exists) {
      final existingData = Map<String, dynamic>.from(snapshot.value as Map);
      final existingRecord = GameRecord.fromJson(existingData);

      if (record.steps < existingRecord.steps) {
        await dbRef.set(record.toJson());
        return SaveRecordResult.previousRecordBeaten;
      } else {
        return SaveRecordResult.noNewRecord;
      }
    } else {
      await dbRef.set(record.toJson());
      return SaveRecordResult.newRecord;
    }
  }

}