import "../lib/unification.dart";



void main() {
  var test = unify(
    new List()
      ..add(
        new Tupl(
          new Term("b0", [new Term("b1", []), new Term("b2", [])]),
          new Term("b0", [new Term("b1", []), new Term("b2", [])]),
        ),
      ),
  ).result();
  var mgu = test;
  print(mgu.toString());
}
