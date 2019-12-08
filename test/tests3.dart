import "package:test/test.dart";
import "package:tailcalls/tailcalls.dart";
import "package:unification/src/unification3.dart";

// test for trampolined version

void main() {
  Unification<String, String> u = Unification<String, String>();

  group("Unification (trampolined version)", () {
    test("zwei Variablen", () {
      var test1 = u.unifyTc(
        List()
          ..add(
            Tupl<Termtype<String, String>, Termtype<String, String>>(
              Var("a"),
              Var("b"),
            ),
          ),
      );
      List<Tupl<String, Termtype<String, String>>> res = test1.result();
      print(res.toString());
    });

    test("Keine Variablen nur Terme", () {
      List<Tupl<String, Termtype<String, String>>> test2 = u.unify(
        List<Tupl<Termtype<String, String>, Termtype<String, String>>>()
          ..add(
            Tupl<Term<String, String>, Term<String, String>>(
              Term("b0", [
                Term("b1", List<Termtype<String, String>>()),
                Term("b2", <Termtype<String, String>>[])
              ]),
              Term("b0", [
                Term("b1", <Termtype<String, String>>[]),
                Term("b2", <Termtype<String, String>>[])
              ]),
            ),
          ),
      );
      print(test2.toString());
    });

    test(" Variable und Term ", () {
      List<Tupl<String, Termtype<String, String>>> test3 = u.unify(
        List()
          ..add(
            Tupl(
              Term("a", []),
              Var("b"),
            ),
          ),
      );

      print(test3.toString());
    });
    test("Zirkulariät", () {
      var a = Term<String, String>(
        "a",
        [
          Var("b"),
          Term<String, String>("x", <Termtype<String, String>>[]),
          Var("b"),
        ],
      );

      var b = Term<String, String>(
        "a",
        [
          Term<String, String>(
            "y",
            [
              Var("z"),
            ],
          ),
          Term<String, String>("x", <Termtype<String, String>>[]),
          Var<String, String>("z"), // z
        ],
      );

      try {
        var ur = u.unify([Tupl(a, b)]);
        List<Tupl<String, Termtype<String, String>>> res = ur;
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
