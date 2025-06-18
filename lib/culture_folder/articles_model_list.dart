class Article {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String imageUrl;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.content,
  });

  factory Article.fromFirestore(Map<String, dynamic> data) {
    return Article(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      content: data['content'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// List<Article> articles = [
//   Article(
//     id: '1',
//     title: 'Le pagne africain',
//     thumbnailUrl: 'https://example.com/thumb1.jpg',
//     imageUrl: 'https://example.com/image1.jpg',
//     content: '<h2>Le pagne africain</h2><p>Texte formaté ici...</p>',
//   ),
//   // ...autres articles
// ];
