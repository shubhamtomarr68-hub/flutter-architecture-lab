import 'package:equatable/equatable.dart';

import '../../core/result.dart';

class Note extends Equatable {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'createdAt':
        '${createdAt.year.toString().padLeft(4, '0')}-'
        '${createdAt.month.toString().padLeft(2, '0')}-'
        '${createdAt.day.toString().padLeft(2, '0')}',
  };

  factory Note.fromJson(Map<String, dynamic> json) {
    final parts = (json['createdAt'] as String).split('-');
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      createdAt: DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      ),
    );
  }

  @override
  List<Object?> get props => [id, title, body, createdAt];
}

class NoteRules {
  static String? validate({required String title, required String body}) {
    if (title.trim().isEmpty) {
      return 'Enter a title.';
    }
    if (title.trim().length > 80) {
      return 'Title is too long.';
    }
    if (body.trim().length > 500) {
      return 'Body is too long.';
    }
    return null;
  }
}

abstract class NoteRepository {
  Future<Result<List<Note>>> load();

  Future<Result<List<Note>>> save(List<Note> notes);
}
