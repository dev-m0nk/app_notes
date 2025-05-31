class Note {
  int? id;
  String title;
  String content;
  String? category;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
