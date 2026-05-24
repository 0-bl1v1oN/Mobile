import 'arguments.dart';
import 'command_runner_base.dart';

class HelpCommand extends Command {
  @override
  String get name => 'help';

  @override
  String get description => 'Prints usage information to the command line.';

  @override
  String get help =>
      'Use --verbose to print details and --command to print one command.';

  @override
  bool get requiresArgument => false;

  HelpCommand() {
    addFlag(
      name: 'verbose',
      description: 'Print all command options and details.',
    );
    addOption(
      name: 'command',
      abbr: 'c',
      description: 'Print help for one command.',
      valueHelp: 'COMMAND',
    );
  }

  @override
  String run(ArgResults args) {
    final runner = _runner;
    if (runner == null) {
      return 'Help command is not attached to a CommandRunner.';
    }

    final verbose = args.flag('verbose');
    final commandName = args.getOption('command')?.toString();

    if (commandName != null) {
      final cmd = runner.commandByName(commandName);
      if (cmd == null) {
        return 'Unknown command: $commandName';
      }
      return _renderCommand(cmd, verbose: true);
    }

    if (!verbose) {
      return runner.usage();
    }

    return runner.commands
        .map((c) => _renderCommand(c, verbose: true))
        .join('\n\n');
  }

  CommandRunner? _runner;
  void attach(CommandRunner runner) => _runner = runner;

  String _renderCommand(Command command, {required bool verbose}) {
    final buffer = StringBuffer('${command.name}: ${command.description}');
    if (!verbose) return buffer.toString();
    if (command.help.isNotEmpty) {
      buffer.writeln();
      buffer.write('  ${command.help}');
    }
    if (command.requiresArgument) {
      buffer.writeln();
      buffer.write('  Argument: ${command.valueHelp ?? 'VALUE'}');
    }
    if (command.options.isNotEmpty) {
      buffer.writeln();
      buffer.write('  Options:');
      for (final option in command.options) {
        final names =
            '--${option.name}${option.abbr != null ? ', -${option.abbr}' : ''}';
        final suffix = option.valueHelp != null ? ' <${option.valueHelp}>' : '';
        buffer.writeln();
        buffer.write('    $names$suffix: ${option.description}');
      }
    }
    return buffer.toString();
  }
}
