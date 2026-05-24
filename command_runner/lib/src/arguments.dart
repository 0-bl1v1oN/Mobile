import 'dart:async';

enum OptionType { flag, option }

abstract class Argument {
  String get name;
  String get description;
  String get help;
}

class Option extends Argument {
  Option({
    required this.name,
    this.abbr,
    required this.description,
    this.help = '',
    this.defaultValue,
    this.valueHelp,
    required this.type,
  });

  @override
  final String name;
  final String? abbr;
  @override
  final String description;
  @override
  final String help;
  final Object? defaultValue;
  final String? valueHelp;
  final OptionType type;

  bool get requiresValue => type == OptionType.option;
}

abstract class Command extends Argument {
  final List<Option> _options = <Option>[];

  Object? get defaultValue => null;
  String? get valueHelp => null;
  bool get requiresArgument => false;

  List<Option> get options => List.unmodifiable(_options);

  void addFlag({
    required String name,
    required String description,
    String? abbr,
    String help = '',
    bool defaultValue = false,
  }) {
    _options.add(
      Option(
        name: name,
        abbr: abbr,
        description: description,
        help: help,
        defaultValue: defaultValue,
        type: OptionType.flag,
      ),
    );
  }

  void addOption({
    required String name,
    required String description,
    String? abbr,
    String help = '',
    Object? defaultValue,
    String? valueHelp,
  }) {
    _options.add(
      Option(
        name: name,
        abbr: abbr,
        description: description,
        help: help,
        defaultValue: defaultValue,
        valueHelp: valueHelp,
        type: OptionType.option,
      ),
    );
  }

  FutureOr<Object?> run(ArgResults args);
}

class ArgResults {
  ArgResults({required this.command, this.commandArg, required this.options});

  final Command? command;
  final String? commandArg;
  final Map<Option, Object?> options;

  bool flag(String name) => (getOption(name) as bool?) ?? false;

  bool hasOption(String name) =>
      options.keys.any((option) => option.name == name || option.abbr == name);

  Object? getOption(String name) {
    for (final option in options.keys) {
      if (option.name == name || option.abbr == name) {
        return options[option];
      }
    }
    return null;
  }
}
