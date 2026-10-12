import 'package:architecture_lab/app.dart';
import 'package:architecture_lab/features/notes/note_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('adds a note from the home route', (tester) async {
    await tester.pumpWidget(
      ArchitectureLabApp(notes: MemoryNoteRepository(const [])),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('note-title')), 'Integration');
    await tester.enterText(
      find.byKey(const Key('note-body')),
      'Added end to end',
    );
    await tester.tap(find.byKey(const Key('note-save')));
    await tester.pumpAndSettle();
    expect(find.text('Integration'), findsOneWidget);
  });
}
