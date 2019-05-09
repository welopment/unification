import '../lib/unification.dart';
import 'dart:collection';

void main() {
  var res1 = unify(
    List()
      ..add(
        new Tupl(
          1,
          new Var("a"),
        ),
      ),
  );

  var res2 = unify(
    List()
      ..add(
        new Tupl(
          new Var("a"),
          new Var("b"),
        ),
      ),
  );
}
