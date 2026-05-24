import 'dart:io';

import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart' as wikipedia;

class GetArticleCommand extends Command {
  GetArticleCommand({required this.logger});

  final Logger logger;

  @override
  String get name => 'article';
  @override
  String get description => 'Gets article extract by title.';
  @override
  String get help => 'Fetch extract for a Wikipedia article title.';
  @override
  Object get defaultValue => 'cat';

  @override
  Future<String> run(ArgResults args) async {
    final title = args.commandArg ?? defaultValue.toString();
    try {
      final articles = await wikipedia.getArticleByTitle(title);
      if (articles.isEmpty) return 'No article found for $title';
      final article = articles.first;
      return '=== ${article.title} ===\n${article.extract}';
    } on HttpException catch (e, st) {
      logger.severe('Article HTTP error: $e', e, st);
      rethrow;
    } on FormatException catch (e, st) {
      logger.severe('Article parse error: $e', e, st);
      rethrow;
    }
  }
}
