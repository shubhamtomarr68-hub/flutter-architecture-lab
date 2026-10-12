import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/device_label.dart';
import '../design/components.dart';
import '../features/catalog/catalog_page.dart';
import '../features/counter/counter_page.dart';
import '../features/notes/notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _label = 'Reading device…';

  @override
  void initState() {
    super.initState();
    DeviceLabel.read().then((value) {
      if (mounted) {
        setState(() => _label = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Architecture Lab'),
        actions: [
          IconButton(
            tooltip: 'Switch theme',
            onPressed: () =>
                context.read<ThemeCubit>().toggle(Theme.of(context).brightness),
            icon: Icon(
              mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            'Notes use a cubit and a repository. The counter is a second cubit with no shared state. The catalog filter uses Riverpod only inside its own route.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Device label'),
              subtitle: Text(_label),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            title: 'Notes',
            subtitle: 'Cubit, repository, and Result',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const NotesPage())),
          ),
          AppCard(
            title: 'Counter',
            subtitle: 'A cubit that lives only on this route',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CounterPage()),
            ),
          ),
          AppCard(
            title: 'Catalog',
            subtitle: 'Riverpod filter, isolated from notes',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ProviderScope(child: CatalogPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggle(Brightness brightness) {
    emit(brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
