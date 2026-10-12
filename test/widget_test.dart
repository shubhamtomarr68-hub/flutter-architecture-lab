import 'package:architecture_lab/app.dart';
import 'package:architecture_lab/core/device_label.dart';
import 'package:architecture_lab/features/notes/note.dart';
import 'package:architecture_lab/features/notes/note_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('notes, counter, and catalog stay on separate routes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      DeviceLabel.channel,
      (call) async => 'Pixel test',
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        DeviceLabel.channel,
        null,
      ),
    );

    await tester.pumpWidget(
      ArchitectureLabApp(
        notes: MemoryNoteRepository([
          Note(
            id: 'note-1',
            title: 'Existing note',
            body: 'Already stored',
            createdAt: DateTime(2026, 10, 12),
          ),
        ]),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pixel test'), findsOneWidget);

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('Existing note'), findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('note-save')));
    await tester.pumpAndSettle();
    expect(find.text('Enter a title.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('note-title')), 'New note');
    await tester.enterText(
      find.byKey(const Key('note-body')),
      'Written in the lab',
    );
    await tester.tap(find.byKey(const Key('note-save')));
    await tester.pumpAndSettle();
    expect(find.text('New note'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Counter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plus'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('New note'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Catalog'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('topic-search')), 'riverpod');
    await tester.pumpAndSettle();
    expect(find.text('Riverpod'), findsOneWidget);
    expect(find.text('Repository'), findsNothing);
  });
}
