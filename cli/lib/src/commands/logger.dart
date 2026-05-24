import 'dart:io';

import 'package:logging/logging.dart';

Logger initFileLogger(String name) {
  final logsDir = Directory('logs');
  if (!logsDir.existsSync()) {
    logsDir.createSync(recursive: true);
  }

  final now = DateTime.now().toUtc();
  final fileName =
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.log';
  final file = File('${logsDir.path}/$fileName');
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }

  hierarchicalLoggingEnabled = true;
  final logger = Logger(name)..level = Level.ALL;

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final line =
        '[${record.time.toIso8601String()}] ${record.level.name} ${record.loggerName}: ${record.message}';
    file.writeAsStringSync('$line\n', mode: FileMode.append, flush: true);
  });

  return logger;
}
