import "package:test/test.dart";
import "package:tailcalls/tailcalls.dart";
import "../lib/unification.dart";

void main() {
  print(unify(
    new List()
      ..add(
        new Tupl<Termtype<String>, Termtype<String>>(
          new Var("a"),
          new Var("b"),
        ),
      ),
  ));
  print(unify(
    List()
      ..add(
        Tupl<Termtype<String>, Termtype<String>>(
          Var("a"),
          Term("1", [Term("2", null)]),
        ),
      ),
  ));
}
