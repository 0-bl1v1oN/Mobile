class TitlesSet {
  const TitlesSet({
    required this.canonical,
    required this.normalized,
    required this.display,
  });

  final String canonical;
  final String normalized;
  final String display;

  factory TitlesSet.fromJson(Object? json) {
    return switch (json) {
      {
        'canonical': String canonical,
        'normalized': String normalized,
        'display': String display,
      } =>
        TitlesSet(
          canonical: canonical,
          normalized: normalized,
          display: display,
        ),
      _ => throw const FormatException('Invalid titles set JSON.'),
    };
  }
}
