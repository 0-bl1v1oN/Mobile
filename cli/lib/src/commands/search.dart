import 'dart:io';

import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart' as wikipedia;

class SearchCommand extends Command {
  SearchCommand({required this.logger}) {
    addFlag(
      name: 'im-feeling-lucky',
      description: 'Получить краткое описание для первого результата поиска.',
    );
  }

  final Logger logger;

  @override
  String get name => 'search';
  @override
  String get description => 'Ищет фразу в Wikipedia.';
  @override
  String get help =>
      'Ищет по STRING; опционально используйте --im-feeling-lucky для краткого описания первого результата.';
  @override
  bool get requiresArgument => true;
  @override
  String get valueHelp => 'STRING';

  @override
  Future<String> run(ArgResults args) async {
    try {
      final term = args.commandArg!;
      final results = await wikipedia.search(term);
      final buffer = StringBuffer('Результаты поиска:');
      for (final item in results.results) {
        buffer.writeln();
        buffer.write('${item.title} - ${item.description ?? ''}');
      }

      if (args.flag('im-feeling-lucky') && results.results.isNotEmpty) {
        final top = results.results.first;
        final summary = await wikipedia.getArticleSummaryByTitle(top.key);
        return 'Вам повезло!\n${summary.title}\n${summary.description ?? ''}\n${summary.extract}\nВсе результаты:\n$buffer';
      }

      return buffer.toString();
    } on HttpException catch (e, st) {
      logger.severe('Ошибка HTTP при поиске: $e', e, st);
      rethrow;
    } on FormatException catch (e, st) {
      logger.severe('Ошибка разбора ответа поиска: $e', e, st);
      rethrow;
    }
  }
}
