unification
===========

This project is an implementation of logical first-order unification.

A first-order unification procedure unify is given by this library. It 
can be applied on two terms of type Termtype that are also given by the 
library. 

The solution of a unification problem is a substitution, that is, 
a mapping assigning a symbolic value to each variable of the problem's expressions.

The unification procedure reports unsolvability for a given problem or 
computes the complete and minimal substitution set containing the
most general unifier. This is a set covering all solutions containing 
no redundant members.

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











