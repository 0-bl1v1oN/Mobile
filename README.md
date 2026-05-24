## Packages
- `command_runner`: парсинг команд/опций, help, callbacks вывода/ошибок, ANSI-утилиты.
- `wikipedia`: typed модели, JSON-десериализация, HTTP API клиент к Wikipedia.
- `cli`: исполняемый CLI, команды `help`, `search`, `article`, файл-логгер.
## Run
```bash
dart pub get
dart run cli/bin/cli.dart help
dart run cli/bin/cli.dart help --verbose
dart run cli/bin/cli.dart search dart
dart run cli/bin/cli.dart article cat
```
## Test
```bash
cd wikipedia
dart test
```