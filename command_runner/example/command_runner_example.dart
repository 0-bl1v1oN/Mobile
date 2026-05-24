import 'package:command_runner/command_runner.dart';

void main() async {
  final runner = CommandRunner(
    onOutput: print,
    onError: (e) => print('Error: $e'),
  );
  final help = HelpCommand();
  help.attach(runner);
  runner.addCommand(help);
  await runner.run(['help']);
}
