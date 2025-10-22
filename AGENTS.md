# Repository Guidelines

## Codex / AI End of Every Task
Check, for my request, whether there are any reusable components available in public packages or in the existing code base.  If so, ask me if I want to use them before you make a change.
If the branch is on master/main then stop and do not make any changes.  This is to prevent any accidental changes to the main branch.

## Codex / AI End of Every Task
run `flutter analyze` or `dart analyze` to check for any violations. Be mindful that this needs to be done in each package separately.

## Project Structure & Module Organization
The main package Flutter application lives in the root directory.
The example app with demos lives in example/.

## Build, Test, and Development Commands
Run `flutter pub get` in the app and each package after pulling changes.

Currently not really supporting any other platforms apart from macos.

## Coding Style & Naming Conventions
Follow the repo-wide `analysis_options.yaml` files: they preserve trailing commas, set a wide page width (1000), and intentionally relax a handful of Flutter lint rules to keep iteration fast.

Always run `dart format --line-length 1000 .` (or `flutter format .`) before committing; the formatter aligns with the configured width.

Use PascalCase for widgets and classes, camelCase for methods and variables.  Filenames should match the main widget, method or class name.  All widgets should have be prepended with a W (widget) or S (screen). Avoid introducing prints in production code; prefer logged instrumentation when available.

Use the `morphy` package for any sealed classes and for any state or event definitions in bloc/cubit implementations.

To generate the necessary boilerplate for `morphy`, run `dart run build_runner build --delete-conflicting-outputs` or `flutter pub run build_runner build --delete-conflicting-outputs` or if you want to keep a watcher running, use `dart run build_runner watch --delete-conflicting-outputs` or `flutter pub run build_runner watch --delete-conflicting-outputs`.

## Bloc/Cubit Guidelines
Use `flutter_bloc` for state management. Each Bloc or Cubit should reside in its own
file, named after the Bloc/Cubit (e.g., `task_cubit.dart`).
Name states and events clearly to reflect their purpose (e.g., `TaskLoading`, `TaskLoaded`, `TaskError`).
Use Morphy classes for defining state classes.
Try to keep business logic within the Bloc/Cubit, avoiding direct logic in UI components
except very simple UI logic.
For simple user state persistance, use `hydrated_bloc` to automatically save and restore state.
`hydrated_bloc` should not be used for data storage that is not user state, for example do not use it to store the list of tasks or projects, instead use the repositories and firestore for that.
For blocs, always define the state, bloc and events in different files.

## Design / Style Guidelines
When creating new widgets, prefer composition of existing widgets over creating new ones from scratch.
Also when creating new widgets, consider creating them as reusable widgets in a commonWidgets folder if they are likely to be reused.
All single line if statements without an else should use the a comment to break the line like the following format:
```
if (condition) //
  doSomething();
```

## Documentation Standards
Document all functions and classes with DartDoc comments (`///`).

For complex widgets or classes, include usage examples.

For any existing files that have been edited, for every line codex change, add `// codex:` above the line explaining the change and reasoning and what that line of code is doing (skipping import statements, closing brackets and other non functional lines).  Be careful that the line you have commented has actually been changed by codex and is not just an unchanged line that has been moved or reformatted.

For any new files, just comment as normal without the `// codex:` comments
but do add plenty of doc comments, especially where the code is not self explanatory.
As a minimum one doc comment per four lines of code, document any new variables if they are not self explanatory.
Treat the user of the code as someone who has never seen it before and needs to understand what it is doing.  Also especially comment any rarely used apis, functions or complex algorithms or logic.

Use template and macro for any reusable documentation patterns, only where we can reuse the document and add a @macro.
For example, callable classes should duplicate the class doc comment on the `call` method and class constructors should duplicate the class doc comment on the constructor.  Any named parameter, public properties or getter or setters should be have doc comments also For example:

```dart
/// {@template MyClass}
/// Reusable documentation
/// {@endtemplate}
class MyClass {
  /// Property description.
  final double myProperty;  
  
  /// {@macro MyClass}
  MyClass();

  /// {@macro MyClass}
  void call() {}
}
```

## Testing Guidelines
Co-locate unit tests beside the module they exercise (e.g., `myprojectd/test`).  Name tests to describe behavior (e.g., `should_render_scaled_slider`). Aim to extend coverage whenever touching business logic; mirror new models or repositories with matching test doubles. Run the relevant command (see above) locally and ensure snapshots or golden files are regenerated when UI changes.

## Ignore the following (I will handle these myself or add them back above later):
run `.github/hooks/pre-commit.sh` in root of repo (not the sub projects) to check all tests
