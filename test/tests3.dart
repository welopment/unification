import "package:test/test.dart";
import "package:tailcalls/tailcalls.dart";
import "package:unification/src/unification3.dart";

// test for trampolined version

void main() {
  Unification<String> u = new Unification<String>();

  group("Unification (trampolined version)", () {
    test("zwei Variablen", () {
      var test1 = u.unifyTc(
        new List()
          ..add(
            new Tupl<Termtype<String>, Termtype<String>>(
              new Var("a"),
              new Var("b"),
            ),
          ),
      );
      List<Tupl<String, Termtype<String>>> res = test1.result();
      print(res.toString());
    });

    test("Keine Variablen nur Terme", () {
      List<Tupl<String, Termtype<String>>> test2 = u.unify(
        new List<Tupl<Termtype<String>, Termtype<String>>>()
          ..add(
            new Tupl<Term<String>, Term<String>>(
              new Term<String>("b0", [
                new Term<String>("b1", new List<Termtype<String>>()),
                new Term<String>("b2", <Termtype<String>>[])
              ]),
              new Term<String>("b0", [
                new Term<String>("b1", <Termtype<String>>[]),
                new Term<String>("b2", <Termtype<String>>[])
              ]),
            ),
          ),
      );
      print(test2.toString());
    });

    test(" Variable und Term ", () {
      List<Tupl<String, Termtype<String>>> test3 = u.unify(
        new List()
          ..add(
            new Tupl(
              new Term("a", []),
              new Var("b"),
            ),
          ),
      );

      print(test3.toString());
    });
    test("Zirkulariät", () {
      var a = new Term<String>(
        "a",
        [
          new Var("b"),
          new Term<String>("x", <Termtype<String>>[]),
          new Var("b"),
        ],
      );

      var b = new Term(
        "a",
        [
          new Term(
            "y",
            [
              new Var("z"),
            ],
          ),
          new Term<String>("x", <Termtype<String>>[]),
          new Var("z"), // z
        ],
      );

      try {
        var ur = u.unify([new Tupl(a, b)]);
        List<Tupl<String, Termtype<String>>> res = ur;
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
