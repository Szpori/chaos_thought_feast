import 'dart:io';
import 'package:chaos_thought_feast/services/wiki_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class UriFake extends Fake implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(UriFake());
  });

  group('WikiService', () {
    late WikiService wikiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      wikiService = WikiService(client: mockClient); // Inject the mock client
    });

    test('fetchTitlesFromWikipedia returns list of titles on successful http call', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => http.Response('{"parse":{"text":{"*":"<p><b>Example Page</b></p><a title=\\"Valid Title\\">Link</a>"}}}', 200));
      expect(await wikiService.fetchTitlesFromWikipedia("Example_Page", "en"), equals(["Valid Title"]));
    });

    test('fetchTitlesFromWikipedia throws HttpException on non-200 response', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => http.Response('Not Found', 404));
      await expectLater(wikiService.fetchTitlesFromWikipedia("Example_Page", "en"), throwsA(isA<HttpException>()));
    });

    test('fetchIntroText returns intro text on successful http call', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => http.Response('{"query":{"pages":{"12345":{"extract":"Example extract."}}}}', 200));
      expect(await wikiService.fetchIntroText("Example_Page", "en"), equals("Example extract."));
    });

    test('fetchIntroTextWithScore returns intro text with score on successful http call', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => http.Response('{"query":{"pages":{"12345":{"extract":"Example extract."}}}}', 200));
      expect(await wikiService.fetchIntroTextWithScore("Example_Page", ["example"], "en"), isA<String>());
    });

    test('fetchKeywords returns a list of keywords on successful http call', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => http.Response('{"query":{"pages":{"12345":{"extract":"Example extract containing keywords"}}}}', 200));
      expect(await wikiService.fetchKeywords("Example_Page", "en"), contains('keywords'));
    });
  });
}