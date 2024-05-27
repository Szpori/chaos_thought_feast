import 'package:chaos_thought_feast/utils/StringUtils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringUtils Tests', () {
    test('spaceToUnderScore replaces spaces with underscores', () {
      var result = StringUtils.spaceToUnderScore("Hello World");
      expect(result, "Hello_World");
    });

    test('underscoreToSpace replaces underscores with spaces', () {
      var result = StringUtils.underscoreToSpace("Hello_World");
      expect(result, "Hello World");
    });
  });
}