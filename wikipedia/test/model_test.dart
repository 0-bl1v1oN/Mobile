import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:wikipedia/wikipedia.dart';

void main() {
  group('Summary', () {
    test('Summary.fromJson parses fixture', () {
      final json = jsonDecode(
          File('test/test_data/dart_lang_summary.json').readAsStringSync());
      final summary = Summary.fromJson(json);

      expect(summary.title, 'Dart');
      expect(summary.description, 'Programming language');
      expect(summary.titles.display, 'Dart');
    });
  });

  group('Article', () {
    test('Article.listFromJson parses query pages values', () {
      final json =
          jsonDecode(File('test/test_data/cat_extract.json').readAsStringSync())
              as Map<String, dynamic>;
      final pages = (json['query'] as Map<String, dynamic>)['pages']
          as Map<String, dynamic>;
      final articles = Article.listFromJson(pages.values.toList());

      expect(articles, hasLength(1));
      expect(articles.first.title, 'Cat');
    });
  });

  group('SearchResults', () {
    test('SearchResults.fromJson parses fixture', () {
      final json = jsonDecode(
          File('test/test_data/open_search_response.json').readAsStringSync());
      final results = SearchResults.fromJson(json);

      expect(results.searchTerm, 'dart');
      expect(results.results, hasLength(2));
      expect(results.results.first.title, 'Dart');
    });
  });
}
