import 'dart:async';

import 'arguments.dart';
import 'exceptions.dart';

class CommandRunner {
  CommandRunner({
    void Function(String output)? onOutput,
    void Function(Object error)? onError,
  }) : _onOutput = onOutput,
       _onError = onError;

  final void Function(String output)? _onOutput;
  final void Function(Object error)? _onError;

  final Map<String, Command> _commands = <String, Command>{};

  void addCommand(Command command) {
    _commands[command.name] = command;
  }

  String usage() {
    final buffer = StringBuffer(
      'Usage: dart bin/cli.dart <command> [commandArg?] [...options?]',
    );
    for (final command in _commands.values) {
      buffer.writeln();
      buffer.write('${command.name}:  ${command.description}');
    }
    return buffer.toString();
  }

  ArgResults parse(List<String> input) {
    if (input.isEmpty) throw ArgumentException('Input must not be empty.');
    final command = _commands[input.first];
    if (command == null)
      throw ArgumentException('The first word of input must be a command.');

    String? commandArg;
    final options = <Option, Object?>{
      for (final opt in command.options) opt: opt.defaultValue,
    };

    for (var i = 1; i < input.length; i++) {
      final token = input[i];
      if (token.startsWith('-')) {
        final option = command.options
            .where((opt) => '--${opt.name}' == token || '-${opt.abbr}' == token)
            .firstOrNull;
        if (option == null) throw ArgumentException('Unknown option: $token');
        switch (option.type) {
          case OptionType.flag:
            options[option] = true;
          case OptionType.option:
            if (i + 1 >= input.length || input[i + 1].startsWith('-')) {
              throw ArgumentException(
                'Option ${option.name} requires a value.',
              );
            }
            options[option] = input[++i];
        }
      } else {
        if (commandArg != null)
          throw ArgumentException('Too many positional arguments provided.');
        commandArg = token;
      }
    }

    if (command.requiresArgument &&
        commandArg == null &&
        command.defaultValue == null) {
      throw ArgumentException('Command ${command.name} requires an argument.');
    }

    return ArgResults(
      command: command,
      commandArg: commandArg ?? command.defaultValue?.toString(),
      options: options,
    );
  }

  Future<Object?> run(List<String> input) async {
    try {
      final args = parse(input);
      final command = args.command;
      if (command == null) throw ArgumentException('No command to run.');
      final result = await command.run(args);
      if (result case String text when text.isNotEmpty) {
        _onOutput?.call(text);
      }
      return result;
    } on Error {
      rethrow;
    } catch (e) {
      _onError?.call(e);
      return null;
    }
  }

  Iterable<Command> get commands => _commands.values;
  Command? commandByName(String name) => _commands[name];
}
