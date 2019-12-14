import 'package:unification/unification.dart';
import 'dart:collection';

void main() {
  // 1.

  UnificationR<String, Id> u2 = UnificationR<String, Id>();
  /*
  // List<Tuple<Id, Termtype<String, Id>>>
  var res = u2.unify(
      Branch(Id(1, 1), [
        Term(Id(1, 3), [
          Branch(Id(1, 4), [
            V(
              Id(1, 5),
            )
          ])
        ])
      ]),
      Var(Id(2, 2)),
      []); // <Tuple<Id, Termtype<String, Id>>>
  print(res);
  */
  // simplified:
  Termtype<String, Id> term1 = Term(Id(1, 1), [
    Term(Id(1, 1), [
      Term(Id(1, 3), [
        V(
          Id(1, 4),
        ),
      ]),
    ]),
  ]);
  Termtype<String, Id> term2 = Var(Id(2, 2));
  //
  //
  //
  term1 = Term(Id(1, 1), [
    Var(
      Id(1, 2),
    ),
    Var(
      Id(1, 2),
    ),
  ]);
  //
  term2 = Term(Id(2, 1), [
    Var(
      Id(2, 2),
    ),
    Term(Id(2, 3), [
      Var(
        Id(2, 22),
      ),
    ]),
  ]);
  print('Indirect Circularity');
  UnificationR<String, Id> u4 = UnificationR<String, Id>();
  var res0 = u4.unify(term1, term2, []);

  var resS01 = u2.subsitute(res0, term1);
  var resS02 = u2.subsitute(res0, term2);
  print('binding  > ' + res0.toString());
  print('result 1 > ' + resS01.toString());
  print('result 2 > ' + resS02.toString());

  //

  var res01 = UnificationR<String, I<List<int>>>().unify(
      Term(I([1, 0]), [
        Branch(I([1, 1]), [
          Term(I([3]), [
            V(
              I([1, 0]),
            ),
          ]),
        ]),
      ]),
      Var(I([1, 0])),
      []); // <Tuple<I<List<int>>, Termtype<String, I<List<int>>>>>

  print(res01);
  // 2.
  UnificationR<String, String> u = UnificationR<String, String>();

  List<Tuple<String, Termtype<String, String>>> res1 = u.unify(
    Var('a'),
    Var('a'),
    [], // <Tuple<String, Termtype<String, String>>>
  );

  List<Tuple<String, Termtype<String, String>>> res2 = u.unify(
    Var('a'),
    Var('b'),
    [], // <Tuple<String, Termtype<String, String>>>
  );

  print(res1);
  print(res2);
}

/*
[(
  Id(clause 2, id:2), 
  Term(id: Id(clause 1, id:1), 
       termlist: [Branch(id: Id(clause 1, id:1), 
                         termlist: [Term(id: Id(clause 1, id:3), 
                                          termlist: [V(Id(clause 1, id:4))])])]))]




result  > Term(id: Id(clause 1, id:1), termlist: [Term(id: Id(clause 1, id:1), termlist: [Term(id: Id(clause 1, id:3), termlist: [V(Id(clause 1, id:4))])])])
*/
