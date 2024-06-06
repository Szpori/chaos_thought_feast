import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart' as html_parser; // Use the html package
import 'package:html/dom.dart' as dom;
import 'lang_service.dart';

class WikiService {
  final http.Client client;

  WikiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<String>> fetchTitlesFromWikipedia(String pageTitle) async {
    List<String> titles = [];
    try {
      final response = await client.get(Uri.parse('https://en.wikipedia.org/w/api.php?action=parse&page=$pageTitle&prop=text&format=json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pageHtml = data['parse']['text']['*'];

        // Attempt to find the first occurrence of <p><b>PageTitle</b>
        final String normalizedTitle = pageTitle.replaceAll('_', ' '); // Normalize the page title by replacing underscores
        final List<String> titleParts = normalizedTitle.split(' '); // Split the title into parts

        final String regexPattern = '<p>[^<]*?<b>\\s*${titleParts[0]}(?:\\s+${titleParts.skip(1).join('\\s+')})?\\s*</b>';

        final titlePattern = RegExp(regexPattern, caseSensitive: false, dotAll: true); // Using dotAll to allow '.' to match newline characters
        String? filteredHtml;

        if (titlePattern.hasMatch(pageHtml)) {
          print("MATCH");
          final match = titlePattern.firstMatch(pageHtml);
          final startIndex = match?.start ?? 0; // Ensure we have a start index even if match is null
          filteredHtml = pageHtml.substring(startIndex);
        } else {
          print("NOT MATCH");
          // Fallback to the original HTML if specific pattern not found
          filteredHtml = pageHtml;
        }

        final filteredDocument = html_parser.parse(filteredHtml);

        // Now extract all the links from the filtered HTML
        final links = filteredDocument.querySelectorAll('a');

        for (var link in links) {
          var title = link.attributes['title'];
          if (title != null && _isValidTitle(title)) {
            titles.add(title);
          }
        }
      } else {
        throw HttpException('Failed to load text from Wikipedia');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
    return titles;
  }

  bool _isValidTitle(String title) {
    // Your filtering logic here
    return !title.endsWith("(identifier)") && !title.contains(":") && !title.contains(RegExp(r'ISO \d+-\d+'));
  }

  Future<String> fetchIntroText(String pageTitle) async {
    try {
      final response = await client.get(Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&titles=$pageTitle&prop=extracts&exintro&explaintext&format=json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']['pages'];
        final pageId = pages.keys.first;
        final extract = pages[pageId]['extract'];

        //List<String> keywords = extractKeywords(extract); // Use the extractKeywords function
        //print("Extracted Keywords: $keywords"); // Output the keywords to the console


        return cutToThreeSentencesOrSixtyWords(extract);
      } else {
        throw Exception('Failed to load intro text from Wikipedia');
      }
    } catch (e) {
      print(e.toString());
      return "No content found";
    }
  }

  Future<String> fetchIntroTextWithScore(String pageTitle, List<String> currentTitleKeywords) async {
    try {
      final response = await client.get(Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&titles=$pageTitle&prop=extracts&exintro&explaintext&format=json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']['pages'];
        final pageId = pages.keys.first;
        final extract = pages[pageId]['extract'];

        var description = cutToThreeSentencesOrSixtyWords(extract);

        List<String> keywords = extractKeywords(description);
        //print("Extracted Keywords: $keywords");

        double jaccardSimilarity = calculateJaccardSimilarity(currentTitleKeywords, keywords);

        String textWithScore = 'Similarity Score: $jaccardSimilarity\n$description';

        return textWithScore;
      } else {
        throw Exception('Failed to load intro text from Wikipedia');
      }
    } catch (e) {
      print(e.toString());
      return "No content found";
    }
  }

  double calculateJaccardSimilarity(List<String> set1, List<String> set2) {
    Set<String> s1 = set1.toSet();
    Set<String> s2 = set2.toSet();

    double intersection = s1.intersection(s2).length.toDouble();
    double union = s1.union(s2).length.toDouble();

    return intersection / union;
  }

  Future<List<String>> fetchKeywords(String pageTitle) async {
    try {
      final response = await client.get(Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&titles=$pageTitle&prop=extracts&exintro&explaintext&format=json'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']['pages'];
        final pageId = pages.keys.first;
        final extract = pages[pageId]['extract'];

        List<String> keywords = extractKeywords(extract);
        //print("Extracted Keywords: $keywords");

        return keywords;
      } else {
        throw Exception('Failed to load intro text from Wikipedia');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  String cutToThreeSentencesOrSixtyWords(String text) {
    var sentenceCount = 0;
    var wordCount = 0;
    final words = text.split(' ');

    StringBuffer buffer = StringBuffer();

    for (var word in words) {
      if (word.isEmpty) continue;
      buffer.write(word);
      buffer.write(' ');
      wordCount++;

      if (word.endsWith('.') || word.endsWith('?') || word.endsWith('!')) {
        sentenceCount++;
        if (sentenceCount == 3 || wordCount >= 60) {
          break;
        }
      }
    }

    return buffer.toString().trim();
  }
}