Unification
===========

A library providing implementations of first-order logical unification for dart and flutter.

# Getting started

Add the dependency to your pubspec.yaml file:

```yaml
dependencies:
  unification: #latest version
```

Add the import statement to your source files:

```dart
import 'package:unification/unification.dart';
```

Or, give it a try and run the example:

```dart
dart ./example/main.dart 
```

Modify the example to test more less simple tasks!

# Example:

```dart
  import "package:unification/unification.dart";
  
  UnificationR<String, String> u = UnificationR<String, String>();

  List<Tuple<String, Termtype<String, String>>> res1 = u.unify(
      <Tuple<Var<String, String>, Var<String, String>>>[]..add(
          Tuple<Var<String, String>, Var<String, String>>(
            Var('a'),
            Var('a'),
          ),
        ),
      <Tuple<String, Termtype<String, String>>>[]);

  List<Tuple<String, Termtype<String, String>>> res2 = u.unify(
      <Tuple<Var<String, String>, Var<String, String>>>[]..add(
          Tuple(
            Var('a'),
            Var('b'),
          ),
        ),
      <Tuple<String, Termtype<String, String>>>[]);

  print(res1);
  print(res2);
```



[Read more](https://en.wikipedia.org/wiki/Unification) 
about unification in logic on Wikipedia.











