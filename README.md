unification
===========

Implementations of first-order logical unification.


# Example:

```dart
  import "package:unification/unification.dart";
  
  UnificationR<String, String> u = UnificationR<String, String>();

  List<Tupl<String, Termtype<String, String>>> res1 = u.unify(
      <Tupl<Var<String, String>, Var<String, String>>>[]..add(
          Tupl<Var<String, String>, Var<String, String>>(
            Var('a'),
            Var('a'),
          ),
        ),
      <Tupl<String, Termtype<String, String>>>[]);

  List<Tupl<String, Termtype<String, String>>> res2 = u.unify(
      <Tupl<Var<String, String>, Var<String, String>>>[]..add(
          Tupl(
            Var('a'),
            Var('b'),
          ),
        ),
      <Tupl<String, Termtype<String, String>>>[]);

  print(res1);
  print(res2);
```



[Read more](https://en.wikipedia.org/wiki/Unification) 
about unification in logic on Wikipedia.











