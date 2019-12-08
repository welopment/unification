unification
===========

This is an implementation of logical first-order unification.

The solution of a unification problem is a substitution, that is, 
a mapping assigning a symbolic value to each variable of the problem's expressions.

# Example:

```dart
import "package:tailcalls/tailcalls.dart";
import "package:unification/unification.dart";

var test = unify(
        List()
        ..add(
            Tupl(
              Term("b0", [  Term("b1", []),  Term("b2", [])]),
              Term("b0", [  Term("b1", []),  Term("b2", [])]),
          ),
        ),
    ).result();
var mgu = test;
print(mgu.toString());
```



[Read more](https://en.wikipedia.org/wiki/Unification) 
about unification in logic on Wikipedia.











