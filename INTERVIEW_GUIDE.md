# Architecture Lab interview guide

## Architecture decisions

1. **Cubit for notes, Cubit for the counter, Riverpod for the catalog.** They are different routes. The catalog `ProviderScope` is created when that route opens. Notes do not watch Riverpod providers.

2. **`Result` instead of thrown storage errors.** `NoteRepository.load` and `save` return `Success` or `Failure`. A failed save returns the message and does not replace the list.

3. **GetIt only in `main`.** It registers `FileNoteRepository`. `ArchitectureLabApp` receives the repository. Tests pass `MemoryNoteRepository` and never call `configureDependencies`.

4. **The counter cubit is created in the route and is not in GetIt.** Leaving the route disposes it. Changing the count cannot change the note list.

5. **The device label has a fallback.** `DeviceLabel.read` calls `label` on `com.shubhamtomar.architecture_lab/device`. `MissingPluginException` and `PlatformException` fall back to `defaultTargetPlatform.name`.

## Questions

**Why not use Riverpod for notes too?**
It would work. This lab is here to show that the choice is per feature. Notes already have a cubit and a `Result`. Putting a second state library in that feature would not explain either one more clearly.

**What does the catalog prove?**
A derived list. `topicQueryProvider` holds the string. `visibleTopicsProvider` filters `labTopics`. There is no repository because the data does not change.

**How are notes stored?**
`FileNoteRepository` writes version 1 JSON to `lab_notes.json`. The first launch has no file and loads an empty list. Tests use memory.

**Was the platform channel run on a phone?**
No. Tests install a mock handler, and a second test calls the channel with no handler and expects the platform name. The Kotlin and Swift handlers are in the project and were not executed in this session.

**How does navigation work?**
`Navigator.push` with `MaterialPageRoute`. The notes route reads `NoteRepository` from the parent `RepositoryProvider`. The catalog route builds its own `ProviderScope`.

## A hard bug, and the fix

The add-note sheet is a new route, so it could not see the page's `NotesCubit`. The sheet is wrapped in `BlocProvider.value` with the page cubit. Save and validation use that cubit.

## Error handling

- Invalid title or body: returned to the sheet, no save.
- `Failure` from save: the previous notes stay on screen.
- `Failure` from load: the page shows the message and Retry.
- Platform channel errors: the home label becomes the target platform name.

## Testing

- Note validation, failed save, and a temp-file round trip
- Channel success and missing-handler fallback
- Widget test: existing note, empty title, new note, counter does not show that note, catalog filter hides Repository when the query is `riverpod`

The integration test file was not run. See the README.

## Trade-offs

- Two state libraries in one repo is deliberate and easy to misuse. The route boundary is the rule.
- GetIt plus constructor injection is only justified for the file repository at startup.
- A constant catalog is enough to show a derived provider and too small to show caching.

## What would change in production

- One state approach per app, chosen for the product, not for a tour
- A logged-in user before notes leave the device
- A device run of the platform channel and of `integration_test/app_test.dart`
- Screenshots
