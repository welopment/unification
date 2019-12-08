import "package:test/test.dart";
import "package:unification/src/unification1.dart";
// test for not trampolined version

void main() {
  UnificationR<String, String> u = UnificationR<String, String>();

  group("Property", () {
    test("Property.value: get, set ", () {
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

      var test2 = u.unify(
        List()
          ..add(
            Tupl(
              Term("b0", [Term("b1", []), Term("b2", [])]),
              Term("b0", [Term("b1", []), Term("b2", [])]),
            ),
          ),
      );
      print(test2.toString());

      var test3 = u.unify(
        List()
          ..add(
            Tupl(
              Term("a", []),
              Var("b"),
            ),
          ),
      );

      print(test3.toString());

      var a = Term<String, String>(
        "a",
        [
          Var<String, String>("b"),
          Term("x", <Termtype<String, String>>[]),
          Var("b"),
        ],
      );

      var b = Term<String, String>(
        "a",
        [
          Term(
            "y",
            [
              Var("z"),
            ],
          ),
          Term<String, String>("x", <Termtype<String, String>>[]),
          Var("z1"), // z
        ],
      );

      try {
        List<Tupl<String, Termtype>> ur = u.unify([Tupl(a, b)]);
        List<Tupl<String, Termtype>> res = ur;
        print("\n" + res.toString() + "\n");
      } on Exception catch (e) {
        print("Exception in Test: $e");
      }
    });
  });
}
