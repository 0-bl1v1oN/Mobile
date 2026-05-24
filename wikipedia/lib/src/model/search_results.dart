class SearchResult {
  const SearchResult({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
  });

  final int id;
  final String key;
  final String title;
  final String? description;

  factory SearchResult.fromJson(Object? json) {
    return switch (json) {
      {
        'id': int id,
        'key': String key,
        'title': String title,
        'description': final String? description,
      } =>
        SearchResult(id: id, key: key, title: title, description: description),
      _ => throw const FormatException('Invalid search result JSON.'),
    };
  }
}

class SearchResults {
  const SearchResults({required this.searchTerm, required this.results});

  final String searchTerm;
  final List<SearchResult> results;

  factory SearchResults.fromJson(Object? json) {
    return switch (json) {
      {'searchTerm': String searchTerm, 'results': List results} =>
        SearchResults(
          searchTerm: searchTerm,
          results: results.map(SearchResult.fromJson).toList(growable: false),
        ),
      _ => throw const FormatException('Invalid search results JSON.'),
    };
  }
}
