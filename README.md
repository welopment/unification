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
  
 
  //
   Termtype<String, Id> term1 = Term(Id(1, 1), [
    Var(
      Id(1, 2),
    ),
    Var(
      Id(1, 2),
    ),
  ]);
  //
  Termtype<String, Id> term2 = Term(Id(2, 1), [
    Var(
      Id(2, 2),
    ),
    Term(Id(2, 3), [
      Var(
        Id(2, 2),
      ),
    ]),
  ]);
  print('Occurs Check: Circularity.');
  UnificationR<String, Id> u = UnificationR<String, Id>();
  var mgu = u.unify(term1, term2, []);
  var unifiedTerm1 = u.subsitute(mgu, term1);
  var unifiedTerm2 = u.subsitute(mgu, term2);
  print('mgu      > ' + mgu.toString());
  print('term 1   > ' + unifiedTerm1.toString());
  print('term 2   > ' + unifiedTerm2.toString());
```



[Read more](https://en.wikipedia.org/wiki/Unification) 
about unification in logic on Wikipedia.











