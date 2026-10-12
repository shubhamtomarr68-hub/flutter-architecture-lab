import 'dart:convert';
import 'dart:io';

import '../../core/result.dart';
import 'note.dart';

class MemoryNoteRepository implements NoteRepository {
  MemoryNoteRepository(
    this.notes, {
    this.failLoad = false,
    this.failSave = false,
  });

  List<Note> notes;
  bool failLoad;
  bool failSave;

  @override
  Future<Result<List<Note>>> load() async {
    if (failLoad) {
      return const Failure('Could not load notes.');
    }
    return Success(notes);
  }

  @override
  Future<Result<List<Note>>> save(List<Note> next) async {
    if (failSave) {
      return const Failure('Could not save notes.');
    }
    notes = next;
    return Success(notes);
  }
}

class FileNoteRepository implements NoteRepository {
  FileNoteRepository({required this.file});

  final File file;

  @override
  Future<Result<List<Note>>> load() async {
    try {
      if (!await file.exists()) {
        return const Success([]);
      }
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic> || decoded['version'] != 1) {
        return const Failure('Could not load notes.');
      }
      final raw = decoded['notes'];
      if (raw is! List) {
        return const Failure('Could not load notes.');
      }
      final notes = raw.map((item) {
        return Note.fromJson(item as Map<String, dynamic>);
      }).toList();
      return Success(notes);
    } catch (_) {
      return const Failure('Could not load notes.');
    }
  }

  @override
  Future<Result<List<Note>>> save(List<Note> notes) async {
    try {
      await file.parent.create(recursive: true);
      const encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(
        encoder.convert({
          'version': 1,
          'notes': notes.map((note) => note.toJson()).toList(),
        }),
      );
      return Success(notes);
    } catch (_) {
      return const Failure('Could not save notes.');
    }
  }
}
