import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/search_results.dart';

Future<SearchResults> search(String searchTerm) async {
  final client = http.Client();
  try {
    final uri = Uri.https('en.wikipedia.org', '/w/rest.php/v1/search/page', {
      'q': searchTerm,
      'limit': '10',
    });
    final response = await client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException('Failed to search pages: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    return switch (data) {
      {'pages': List pages} => SearchResults(
        searchTerm: searchTerm,
        results: pages.map(SearchResult.fromJson).toList(growable: false),
      ),
      _ => throw const FormatException('Invalid search response JSON.'),
    };
  } finally {
    client.close();
  }
}
