import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/summary.dart';

Future<Summary> getRandomArticleSummary() async {
  final client = http.Client();
  try {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Не удалось загрузить случайное краткое описание: ${response.statusCode}',
      );
    }
    return Summary.fromJson(jsonDecode(response.body));
  } finally {
    client.close();
  }
}

Future<Summary> getArticleSummaryByTitle(String articleTitle) async {
  final client = http.Client();
  try {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/summary/$articleTitle',
    );
    final response = await client.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Не удалось загрузить краткое описание статьи: ${response.statusCode}',
      );
    }
    return Summary.fromJson(jsonDecode(response.body));
  } finally {
    client.close();
  }
}
