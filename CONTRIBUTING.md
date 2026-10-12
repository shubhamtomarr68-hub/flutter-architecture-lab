# Contributing

Keep pull requests small.

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Do not mix Cubit and Riverpod inside the notes feature. A new example needs its own route and a sentence in the README that says why.

Commit prefixes: `feat`, `fix`, `docs`, `test`, `refactor`.
