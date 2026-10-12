import 'package:flutter/material.dart';

import 'app.dart';
import 'features/notes/note.dart';
import 'injection.dart';

Future<void> main() async {
  await configureDependencies();
  runApp(ArchitectureLabApp(notes: getIt<NoteRepository>()));
}
