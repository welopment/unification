import 'package:unification/src/terms.dart';
import 'package:unification/unification.dart';
import 'dart:collection';

void main() {
  Unification<String, String> u = Unification<String, String>();

  var res1 = u.unify(
    List<Tupl<Var<String, String>, Var<String, String>>>()
      ..add(
        Tupl<Var<String, String>, Var<String, String>>(
          Var("a"),
          Var("a"),
        ),
      ),
  );

  List<Tupl<String, Termtype<String, String>>> res2 = u.unify(
    List<Tupl<Var<String, String>, Var<String, String>>>()
      ..add(
        Tupl(
          Var<String, String>("a"),
          Var<String, String>("b"),
        ),
      ),
  );
}
