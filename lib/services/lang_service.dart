import 'dart:collection';


Set<String> conjunctions = {"and", "as", "or", "but", "if", "than", "because", "while", "whether"};
Set<String> pronouns = {"the", "you", "that", "it", "he", "his", "they", "I", "this", "what", "we", "your", "which", "she", "their", "them", "these", "her", "him", "my", "who", "its", "me", "our", "us", "something", "those", "several", "neither"};
Set<String> prepositions = {"of", "to", "in", "for", "on", "with", "at", "from", "by", "about", "into", "down", "over", "after", "through", "between", "under", "along", "until", "without"};
Set<String> adverbs = {"not", "when", "there", "how", "up", "out", "then", "so", "no", "first", "now", "only", "very", "just", "where", "much", "before", "too", "also", "around", "well", "here", "why", "again", "off", "away", "near", "below", "last", "never", "always", "together", "often", "once", "later", "far", "really", "almost", "sometimes", "soon", "mostly", "entirely", "commonly", "further", "noticeable"};
Set<String> adjectives = {"he", "a", "one", "all", "an", "each", "other", "many", "some", "more", "new", "little", "most", "good", "great", "mean", "any", "same", "another", "even", "such", "different", "still", "every", "own", "few", "next", "both", "important", "enough", "above", "specific", "total", "affected", "regardless"};
Set<String> verbs = {"is", "was", "are", "be", "have", "had", "were", "can", "said", "use", "do", "will", "would", "make", "like", "has", "go", "see", "could", "been", "call", "am", "did", "get", "come", "made", "may", "take", "does", "must", "need", "might", "being", "leave", "used", "considered", "making", "using", "involve", "having"};

Set<String> nonKeywords = {...conjunctions, ...pronouns, ...prepositions, ...adverbs, ...adjectives, ...verbs};

List<String> extractKeywords(String text) {
  RegExp exp = RegExp(r'\b\w+\b');
  Iterable<RegExpMatch> matches = exp.allMatches(text.toLowerCase());
  List<String> words = matches.map((match) => match.group(0)!).toList();
  List<String> keywords = words.where((word) => !nonKeywords.contains(word)).toList();
  return keywords;
}