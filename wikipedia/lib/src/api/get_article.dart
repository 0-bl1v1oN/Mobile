import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/article.dart';

Future<List<Article>> getArticleByTitle(String title) async {
  final client = http.Client();
  try {
    final uri = Uri.https('en.wikipedia.org', '/w/api.php', {
      'action': 'query',
      'prop': 'extracts',
      'explaintext': '1',
      'titles': title,
      'format': 'json',
    });
    final response = await client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException('Не удалось получить статью: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    return switch (data) {
      {'query': {'pages': Map pages}} => Article.listFromJson(
          pages.values.toList(),
        ),
      _ => throw const FormatException('Некорректный JSON ответа статьи.'),
    };
  } finally {
    client.close();
  }
}
