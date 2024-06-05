import 'package:firebase_database/firebase_database.dart';

import '../domain/entities/game_record.dart';

abstract class IFireDBService {
  Future<SaveRecordResult> saveGameRecord(GameRecord record);
}

enum SaveRecordResult {
  noNewRecord,
  newRecord,
  previousRecordBeaten,
}

class RealFireDBService implements IFireDBService {
  @override
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