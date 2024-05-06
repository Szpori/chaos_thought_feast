import 'game_mode.dart';

class GameRecord {
  final String startConcept;
  final String goalConcept;
  final List<String> path;
  final int steps;
  final GameMode gameMode;
  final String recordHolder;

  GameRecord({
    required this.startConcept,
    required this.goalConcept,
    required this.path,
    required this.steps,
    required this.gameMode,
    required this.recordHolder,
  });

  Map<String, dynamic> toJson() {
    return {
      'startConcept': startConcept,
      'goalConcept': goalConcept,
      'path': path,
      'steps': steps,
      'gameMode': gameMode.toString(),
      'recordHolder': recordHolder,
    };
  }

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    return GameRecord(
      startConcept: json['startConcept'],
      goalConcept: json['goalConcept'],
      path: List<String>.from(json['path']),
      steps: json['steps'],
      gameMode: GameMode.values.firstWhere((e) => e.toString() == json['gameMode']),
      recordHolder: json['recordHolder'],
    );
  }
}