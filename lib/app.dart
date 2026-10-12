import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/notes/note.dart';
import 'presentation/home_page.dart';
import 'theme.dart';

class ArchitectureLabApp extends StatelessWidget {
  const ArchitectureLabApp({super.key, required this.notes});

  final NoteRepository notes;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: notes,
      child: BlocProvider(
        create: (_) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return MaterialApp(
              title: 'Architecture Lab',
              debugShowCheckedModeBanner: false,
              theme: buildLabTheme(Brightness.light),
              darkTheme: buildLabTheme(Brightness.dark),
              themeMode: mode,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}
