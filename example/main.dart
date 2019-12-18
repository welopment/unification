import 'package:unification/unification.dart';
import 'dart:collection';

void main() {
  // 1.

  //
  Termtype<String, Id> term1 = Term(Id(1, 1), [
    Var(
      Id(1, 2),
    ),
    Var(
      Id(1, 2),
    ),
  ]);
  //
  Termtype<String, Id> term2 = Term(Id(2, 1), [
    Var(
      Id(2, 2),
    ),
    Term(Id(2, 3), [
      Var(
        Id(2, 2),
      ),
    ]),
  ]);
  print('Occurs Check: Circularity.');
  UnificationR<String, Id> u = UnificationR<String, Id>();
  var mgu = u.unify(term1, term2, []);
  var unifiedTerm1 = u.subsitute(mgu, term1);
  var unifiedTerm2 = u.subsitute(mgu, term2);
  print('mgu      > ' + mgu.toString());
  print('term 1   > ' + unifiedTerm1.toString());
  print('term 2   > ' + unifiedTerm2.toString());
}
