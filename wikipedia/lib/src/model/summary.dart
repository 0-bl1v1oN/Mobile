import 'title_set.dart';

class Summary {
  const Summary({
    required this.title,
    required this.description,
    required this.extract,
    required this.titles,
  });

  final String title;
  final String? description;
  final String extract;
  final TitlesSet titles;

  factory Summary.fromJson(Object? json) {
    return switch (json) {
      {
        'title': String title,
        'extract': String extract,
        'titles': final Object? titles,
        'description': final String? description,
      } =>
        Summary(
          title: title,
          description: description,
          extract: extract,
          titles: TitlesSet.fromJson(titles),
        ),
      _ => throw const FormatException('Invalid summary JSON.'),
    };
  }
}
