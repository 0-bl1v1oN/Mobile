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
  String get description => 'Получает выдержку статьи по заголовку.';
  @override
  String get help => 'Получить выдержку по заголовку статьи Wikipedia.';
  @override
  Object get defaultValue => 'cat';

  @override
  Future<String> run(ArgResults args) async {
    final title = args.commandArg ?? defaultValue.toString();
    try {
      final articles = await wikipedia.getArticleByTitle(title);
      if (articles.isEmpty) return 'Статья не найдена: $title';
      final article = articles.first;
      return '=== ${article.title} ===\n${article.extract}';
    } on HttpException catch (e, st) {
      logger.severe('Ошибка HTTP при получении статьи: $e', e, st);
      rethrow;
    } on FormatException catch (e, st) {
      logger.severe('Ошибка разбора ответа статьи: $e', e, st);
      rethrow;
    }
  }
}
