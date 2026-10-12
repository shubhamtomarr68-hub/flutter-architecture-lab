import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/result.dart';
import 'note.dart';

enum NotesStatus { loading, ready, failure }

class NotesState extends Equatable {
  const NotesState({
    required this.status,
    required this.notes,
    required this.errorMessage,
  });

  const NotesState.initial()
    : status = NotesStatus.loading,
      notes = const [],
      errorMessage = null;

  final NotesStatus status;
  final List<Note> notes;
  final String? errorMessage;

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, notes, errorMessage];
}

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({required this.repository, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      super(const NotesState.initial());

  final NoteRepository repository;
  final DateTime Function() _clock;

  Future<void> load() async {
    emit(state.copyWith(status: NotesStatus.loading, clearError: true));
    final result = await repository.load();
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            status: NotesStatus.ready,
            notes: value,
            clearError: true,
          ),
        );
      case Failure(:final message):
        emit(
          state.copyWith(status: NotesStatus.failure, errorMessage: message),
        );
    }
  }

  Future<String?> add({required String title, required String body}) async {
    final error = NoteRules.validate(title: title, body: body);
    if (error != null) {
      return error;
    }
    final note = Note(
      id: _nextId(state.notes),
      title: title.trim(),
      body: body.trim(),
      createdAt: _clock(),
    );
    final result = await repository.save([...state.notes, note]);
    switch (result) {
      case Success(:final value):
        emit(
          state.copyWith(
            status: NotesStatus.ready,
            notes: value,
            clearError: true,
          ),
        );
        return null;
      case Failure(:final message):
        return message;
    }
  }

  Future<String?> remove(String id) async {
    final result = await repository.save(
      state.notes.where((note) => note.id != id).toList(),
    );
    switch (result) {
      case Success(:final value):
        emit(state.copyWith(notes: value, status: NotesStatus.ready));
        return null;
      case Failure(:final message):
        return message;
    }
  }

  String _nextId(List<Note> notes) {
    var max = 0;
    for (final note in notes) {
      final match = RegExp(r'^note-(\d+)$').firstMatch(note.id);
      if (match == null) {
        continue;
      }
      final value = int.parse(match.group(1)!);
      if (value > max) {
        max = value;
      }
    }
    return 'note-${max + 1}';
  }
}
