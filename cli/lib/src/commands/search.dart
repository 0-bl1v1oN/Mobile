import 'dart:io';

import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart' as wikipedia;

class SearchCommand extends Command {
  SearchCommand({required this.logger}) {
    addFlag(
      name: 'im-feeling-lucky',
      description: 'Fetch summary for top search result.',
    );
  }

  final Logger logger;

  @override
  String get name => 'search';
  @override
  String get description => 'Searches Wikipedia for a phrase.';
  @override
  String get help =>
      'Search by STRING and optionally use --im-feeling-lucky for top summary.';
  @override
  bool get requiresArgument => true;
  @override
  String get valueHelp => 'STRING';

  @override
  Future<String> run(ArgResults args) async {
    try {
      final term = args.commandArg!;
      final results = await wikipedia.search(term);
      final buffer = StringBuffer('Search results:');
      for (final item in results.results) {
        buffer.writeln();
        buffer.write('${item.title} - ${item.description ?? ''}');
      }

      if (args.flag('im-feeling-lucky') && results.results.isNotEmpty) {
        final top = results.results.first;
        final summary = await wikipedia.getArticleSummaryByTitle(top.key);
        return 'Lucky you!\n${summary.title}\n${summary.description ?? ''}\n${summary.extract}\nAll results:\n$buffer';
      }

      return buffer.toString();
    } on HttpException catch (e, st) {
      logger.severe('Search HTTP error: $e', e, st);
      rethrow;
    } on FormatException catch (e, st) {
      logger.severe('Search parse error: $e', e, st);
      rethrow;
    }
  }
}
