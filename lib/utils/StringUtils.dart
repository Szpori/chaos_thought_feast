class StringUtils {
  /// Converts all spaces in a string to underscores.
  static String spaceToUnderScore(String title) {
    return title.replaceAll(' ', '_');
  }

  /// Converts all underscores in a string to spaces.
  static String underscoreToSpace(String title) {
    return title.replaceAll('_', ' ');
  }
}