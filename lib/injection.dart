import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'features/notes/note.dart';
import 'features/notes/note_repository.dart';

final getIt = GetIt.instance;

/// Registers the on-device note file. Tests construct the app with a memory
/// repository and do not call this.
Future<void> configureDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (getIt.isRegistered<NoteRepository>()) {
    return;
  }
  final directory = await getApplicationDocumentsDirectory();
  getIt.registerSingleton<NoteRepository>(
    FileNoteRepository(file: File('${directory.path}/lab_notes.json')),
  );
}
