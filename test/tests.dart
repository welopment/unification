import "package:test/test.dart";
import "package:tailcalls/tailcalls.dart";
import "package:unification/src/unification.dart";

void main() {
  Unification<String> u = new Unification<String>();

  group("Property", () {
    test("Property.value: get, set ", () {
      dynamic test1 = u.unify(
        new List()
          ..add(
            new Tupl<Termtype<String>, Termtype<String>>(
              new Var("a"),
              new Var("b"),
            ),
          ),
      );
      print(test1.toString());

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

      var ur = u.unify([new Tupl(a, b)]);
      try {
        List<Tupl<String, Termtype<String>>> res = ur; // .result();
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
