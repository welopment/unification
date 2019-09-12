import 'package:unification/src/terms.dart';
import 'package:unification/unification.dart';
import 'dart:collection';

void main() {
  Unification<String, String> u = new Unification<String, String>();

  var res1 = u.unify(
    List<Tupl<Var<String, String>, Var<String, String>>>()
      ..add(
        new Tupl<Var<String, String>, Var<String, String>>(
          new Var("a"),
          new Var("a"),
        ),
      ),
  );

  List<Tupl<String, Termtype<String, String>>> res2 = u.unify(
    List<Tupl<Var<String, String>, Var<String, String>>>()
      ..add(
        new Tupl(
          new Var<String, String>("a"),
          new Var<String, String>("b"),
        ),
      ),
  );
}
