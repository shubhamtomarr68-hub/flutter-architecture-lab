import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../design/components.dart';
import 'note.dart';
import 'notes_cubit.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NotesCubit(repository: context.read<NoteRepository>())..load(),
      child: const _NotesView(),
    );
  }
}

class _NotesView extends StatelessWidget {
  const _NotesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          switch (state.status) {
            case NotesStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NotesStatus.failure:
              return StatusView(
                message: state.errorMessage ?? 'Could not load notes.',
                onRetry: () => context.read<NotesCubit>().load(),
              );
            case NotesStatus.ready:
              if (state.notes.isEmpty) {
                return const StatusView(message: 'No notes yet.');
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: state.notes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.body),
                      trailing: IconButton(
                        tooltip: 'Delete ${note.title}',
                        onPressed: () => _confirmDelete(context, note),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final cubit = context.read<NotesCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('“${note.title}” will be removed from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    final error = await cubit.remove(note.id);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _showAddSheet(BuildContext context) {
    final cubit = context.read<NotesCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          BlocProvider.value(value: cubit, child: const _AddNoteSheet()),
    );
  }
}

class _AddNoteSheet extends StatefulWidget {
  const _AddNoteSheet();

  @override
  State<_AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<_AddNoteSheet> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add note', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AppTextField(
            controller: _title,
            label: 'Title',
            fieldKey: const Key('note-title'),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _body,
            label: 'Body',
            maxLines: 3,
            fieldKey: const Key('note-body'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          AppButton(
            label: 'Save',
            buttonKey: const Key('note-save'),
            onPressed: () async {
              final error = await context.read<NotesCubit>().add(
                title: _title.text,
                body: _body.text,
              );
              if (!context.mounted) {
                return;
              }
              if (error != null) {
                setState(() => _error = error);
                return;
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
