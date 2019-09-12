import "package:test/test.dart";
import "package:unification/src/unification2.dart";
// test for not trampolined version with helpers

void main() {
  UnificationH<String, String> u = new UnificationH<String, String>();

  group("Test", () {
    test("two variables", () {
      var test1 = u.unify(
        new List()
          ..add(
            new Tupl(
              new Var("a"),
              new Var("b"),
            ),
          ),
      );

      print(test1.toString());
    });

    test("unifiable without variables", () {
      var test2 = u.unify(
        new List()
          ..add(
            new Tupl(
              new Term<String, String>("b0", [
                new Term("b1", <Termtype<String, String>>[]),
                new Term("b2", <Termtype<String, String>>[])
              ]),
              new Term<String, String>("b0", [
                new Term("b1", <Termtype<String, String>>[]),
                new Term("b2", <Termtype<String, String>>[])
              ]),
            ),
          ),
      );
      print(test2.toString());
    });
    test("assignment ", () {
      var test3 = u.unify(
        new List()
          ..add(
            new Tupl(
              new Term<String, String>("a", <Termtype<String, String>>[]),
              new Var<String, String>("b"),
            ),
          ),
      );

      print(test3.toString());
    });
    test("zirkulär ", () {
      Term<String, String> a = new Term<String, String>(
        "a",
        [
          new Var("b"),
          new Term("x", <Termtype<String, String>>[]),
          new Var("b"),
        ],
      );

      Term<String, String> b = new Term<String, String>(
        "a",
        [
          new Term(
            "y",
            [
              new Var("z"),
            ],
          ),
          new Term("x", <Termtype<String, String>>[]),
          new Var("z"), // z
        ],
      );

      try {
        List<Tupl<String, Termtype<String, String>>> ur = u
            .unify(<Tupl<Termtype<String, String>, Termtype<String, String>>>[
          new Tupl(a, b)
        ]);
        List<Tupl<String, Termtype<String, String>>> res = ur;
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
