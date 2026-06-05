# Hydrate Yourself — Architecture Rules

## Stack
- Flutter 3.22+, Dart 3.4+
- State: Riverpod 2.5+ with @riverpod annotations and AsyncNotifier
- DB: Drift 2.x with DAOs and reactive streams
- Navigation: go_router 14.x — always use context.go() / context.push()
- HTTP: Dio 5.x

## Rules
1. Feature-first: lib/features/{feature}/{data,domain,presentation}/
2. DB access chain: UI → Provider → Repository → DAO → Drift. Never query DB from UI directly.
3. All providers use @riverpod annotation. Never use ChangeNotifier or setState in feature screens.
4. All domain models use @freezed annotation.
5. Colors: always Theme.of(context).colorScheme.* — never hardcode hex in widgets.
6. Navigation: always context.go() or context.push() — never Navigator.push().
7. Never use WillPopScope (deprecated) — use PopScope.

## After ANY change to a @riverpod, @freezed, or Drift table file
Run: dart run build_runner build --delete-conflicting-outputs

## Do NOT commit
- android/key.properties
- *.jks / *.keystore
- Any file with API keys — use --dart-define instead