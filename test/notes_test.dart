import 'dart:io';

import 'package:architecture_lab/core/result.dart';
import 'package:architecture_lab/features/notes/note.dart';
import 'package:architecture_lab/features/notes/note_repository.dart';
import 'package:architecture_lab/features/notes/notes_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validation rejects an empty title', () {
    expect(NoteRules.validate(title: ' ', body: 'x'), 'Enter a title.');
    expect(NoteRules.validate(title: 'Ship', body: 'Done'), isNull);
  });

  test('failed save keeps the previous notes', () async {
    final repository = MemoryNoteRepository(const []);
    final cubit = NotesCubit(
      repository: repository,
      clock: () => DateTime(2026, 10, 12),
    );
    addTearDown(cubit.close);
    await cubit.load();
    repository.failSave = true;
    expect(
      await cubit.add(title: 'Later', body: 'Not stored'),
      'Could not save notes.',
    );
    expect(cubit.state.notes, isEmpty);
    expect(repository.notes, isEmpty);
  });

  test('file repository round-trips', () async {
    final directory = await Directory.systemTemp.createTemp('lab');
    addTearDown(() => directory.delete(recursive: true));
    final repository = FileNoteRepository(
      file: File('${directory.path}/notes.json'),
    );
    final saved = await repository.save([
      Note(
        id: 'note-1',
        title: 'Lab',
        body: 'File',
        createdAt: DateTime(2026, 10, 12),
      ),
    ]);
    expect(saved, isA<Success<List<Note>>>());
    final loaded = await repository.load();
    expect((loaded as Success<List<Note>>).value.single.title, 'Lab');
  });
}
