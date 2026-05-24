class Article {
  const Article({
    required this.pageId,
    required this.title,
    required this.extract,
  });

  final int pageId;
  final String title;
  final String extract;

  factory Article.fromJson(Object? json) {
    return switch (json) {
      {
        'pageid': int pageId,
        'title': String title,
        'extract': String extract,
      } =>
        Article(pageId: pageId, title: title, extract: extract),
      _ => throw const FormatException('Некорректный JSON статьи.'),
    };
  }

  static List<Article> listFromJson(Object? json) {
    return switch (json) {
      List list => list.map(Article.fromJson).toList(growable: false),
      _ => throw const FormatException('Некорректный JSON списка статей.'),
    };
  }
}
