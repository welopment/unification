import "package:test/test.dart";
import "package:unification/src/unification2.dart";
// test for not trampolined version with helpers

void main() {
  UnificationH<String, String> u = UnificationH<String, String>();

  group("Test", () {
    test("two variables", () {
      var test1 = u.unify(
        List()
          ..add(
            Tupl(
              Var("a"),
              Var("b"),
            ),
          ),
      );

      print(test1.toString());
    });

    test("unifiable without variables", () {
      var test2 = u.unify(
        List()
          ..add(
            Tupl(
              Term<String, String>("b0", [
                Term("b1", <Termtype<String, String>>[]),
                Term("b2", <Termtype<String, String>>[])
              ]),
              Term<String, String>("b0", [
                Term("b1", <Termtype<String, String>>[]),
                Term("b2", <Termtype<String, String>>[])
              ]),
            ),
          ),
      );
      print(test2.toString());
    });
    test("assignment ", () {
      var test3 = u.unify(
        List()
          ..add(
            Tupl(
              Term<String, String>("a", <Termtype<String, String>>[]),
              Var<String, String>("b"),
            ),
          ),
      );

      print(test3.toString());
    });
    test("zirkulär ", () {
      Term<String, String> a = Term<String, String>(
        "a",
        [
          Var("b"),
          Term("x", <Termtype<String, String>>[]),
          Var("b"),
        ],
      );

      Term<String, String> b = Term<String, String>(
        "a",
        [
          Term(
            "y",
            [
              Var("z"),
            ],
          ),
          Term("x", <Termtype<String, String>>[]),
          Var("z"), // z
        ],
      );

      try {
        List<Tupl<String, Termtype<String, String>>> ur = u
            .unify(<Tupl<Termtype<String, String>, Termtype<String, String>>>[
          Tupl(a, b)
        ]);
        List<Tupl<String, Termtype<String, String>>> res = ur;
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
