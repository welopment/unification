import "package:test/test.dart";
import "package:tailcalls/tailcalls.dart";
import "package:unification/src/unification3.dart";

// test for trampolined version

void main() {
  Unification<String, String> u = new Unification<String, String>();

  group("Unification (trampolined version)", () {
    test("zwei Variablen", () {
      var test1 = u.unifyTc(
        new List()
          ..add(
            new Tupl<Termtype<String, String>, Termtype<String, String>>(
              new Var("a"),
              new Var("b"),
            ),
          ),
      );
      List<Tupl<String, Termtype<String, String>>> res = test1.result();
      print(res.toString());
    });

    test("Keine Variablen nur Terme", () {
      List<Tupl<String, Termtype<String, String>>> test2 = u.unify(
        new List<Tupl<Termtype<String, String>, Termtype<String, String>>>()
          ..add(
            new Tupl<Term<String, String>, Term<String, String>>(
              new Term("b0", [
                new Term("b1", new List<Termtype<String, String>>()),
                new Term("b2", <Termtype<String, String>>[])
              ]),
              new Term("b0", [
                new Term("b1", <Termtype<String, String>>[]),
                new Term("b2", <Termtype<String, String>>[])
              ]),
            ),
          ),
      );
      print(test2.toString());
    });

    test(" Variable und Term ", () {
      List<Tupl<String, Termtype<String,  String>>> test3 = u.unify(
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
      var a = new Term<String, String>(
        "a",
        [
          new Var("b"),
          new Term<String, String>("x", <Termtype<String, String>>[]),
          new Var("b"),
        ],
      );

      var b = new Term<String, String>(
        "a",
        [
          new Term<String, String>(
            "y",
            [
              new Var("z"),
            ],
          ),
          new Term<String, String>("x", <Termtype<String, String>>[]),
          new Var<String, String>("z"), // z
        ],
      );

      try {
        var ur = u.unify([new Tupl(a, b)]);
        List<Tupl<String, Termtype<String, String>>> res = ur;
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
