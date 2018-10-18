/*
import "../lib/src/unification3.dart";

void main() {
  var test1 = unify(
    new List()
      ..add(
        new Tupl(
          new Var("a"),
          new Var("b"),
        ),
      ),
  );

  print(test1.toString());

  var test2 = unify(
    new List()
      ..add(
        new Tupl(
          new Term("b0", [new Term("b1", []), new Term("b2", [])]),
          new Term("b0", [new Term("b1", []), new Term("b2", [])]),
        ),
      ),
  );

  print(test2.toString());

  var test3 = unify(
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
      new Term("x", []),
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
      new Term("x", []),
      new Var("z"), // z
    ],
  );

  try {
    List<Tupl<String, Termtype>> ur = unify([new Tupl(a, b)]);
    List<Tupl<String, Termtype>> res = ur;
    print("\n" + res.toString() + "\n");
  } on Exception catch (e) {
    print("Exception in Test: $e");
  }
}
*/