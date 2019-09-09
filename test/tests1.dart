
import "package:test/test.dart";
import "package:unification/src/unification1.dart";
// test for not trampolined version

void main() {
    UnificationR<String> u = new UnificationR<String>();


  group("Property", () {
    test("Property.value: get, set ", () {
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

      var test2 = u.unify(
        new List()
          ..add(
            new Tupl(
              new Term("b0", [new Term("b1", []), new Term("b2", [])]),
              new Term("b0", [new Term("b1", []), new Term("b2", [])]),
            ),
          ),
      );
      print(test2.toString());

      var test3 = u.unify(
        new List()
          ..add(
            new Tupl(
              new Term("a", []),
              new Var("b"),
            ),
          ),
      );

      print(test3.toString());

      var a = new Term(
        "a",
        [
          new Var("b"),
          new Term("x",  <Termtype<String>>[]),
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
          new Var("z1"), // z
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

