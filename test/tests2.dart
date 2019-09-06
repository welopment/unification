import "package:test/test.dart";

import "../lib/src/unification2.dart";

void main() {
  var u = Unification<String>();
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
              new Term<String>("b0", [
                new Term<String>("b1", <Termtype<String>>[]),
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
    test("assignment ", () {
      var test3 = u.unify(
        new List()
          ..add(
            new Tupl(
              new Term("a", <Termtype<String>>[]),
              new Var("b"),
            ),
          ),
      );

      print(test3.toString());
    });
    test("zirkulär ", () {
      var a = new Term(
        "a",
        [
          new Var("b"),
          new Term("x", <Termtype<String>>[]),
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
          new Term("x", <Termtype<String>>[]),
          new Var("z"), // z
        ],
      );

      try {
        List<Tupl<String, Termtype>> ur = u.unify([new Tupl(a, b)]);
        List<Tupl<String, Termtype>> res = ur;
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
