import 'dart:io';

const _ansiReset = '\x1B[0m';

enum ConsoleColor {
  error(220, 38, 38),
  info(37, 99, 235),
  title(16, 185, 129),
  instruction(245, 158, 11),
  normal(255, 255, 255);

  const ConsoleColor(this.r, this.g, this.b);
  final int r;
  final int g;
  final int b;

  String foreground(String text) => '\x1B[38;2;$r;$g;${b}m$text$_ansiReset';
  String background(String text) => '\x1B[48;2;$r;$g;${b}m$text$_ansiReset';
}

void write(String text, {int duration = 50}) {
  stdout.writeln(text);
  if (duration > 0) {
    sleep(Duration(milliseconds: duration));
  }
}

extension StyledText on String {
  String get errorText => ConsoleColor.error.foreground(this);
  String get instructionText => ConsoleColor.instruction.foreground(this);
  String get titleText => ConsoleColor.title.foreground(this);

  List<String> splitLinesByLength(int length) {
    if (length <= 0 || this.length <= length) return [this];
    final chunks = <String>[];
    for (var i = 0; i < this.length; i += length) {
      final end = (i + length < this.length) ? i + length : this.length;
      chunks.add(substring(i, end));
    }
    return chunks;
  }
}
