import 'package:cli/cli.dart';
import 'package:command_runner/command_runner.dart';

Future<void> main(List<String> arguments) async {
  final logger = initFileLogger('dartpedia');

  final runner = CommandRunner(
    onOutput: (output) => write(output),
    onError: (error) {
      if (error is Error) throw error;
      if (error is Exception) {
        logger.severe('Исключение CLI: $error');
      }
      write('$error'.errorText);
    },
  );

  final help = HelpCommand()..attach(runner);
  runner.addCommand(help);
  runner.addCommand(SearchCommand(logger: logger));
  runner.addCommand(GetArticleCommand(logger: logger));

  await runner.run(arguments);
}
