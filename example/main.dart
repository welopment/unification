import 'package:unification/src/terms.dart';
import 'package:unification/unification.dart';
import 'dart:collection';

class Id {
  Id(int clause, int id)
      : _id = id,
        _clause = clause {
    _unique++;
  }
  //
  final int _clause;
  int get clause => _clause;
  //
  final int _id;
  int get id => _id;
  //
  static int _unique = 0;
  int get unique => _unique;

  @override
  bool operator ==(dynamic other) {
    if (other is Id) {
      bool equalname = _id == other.id;
      bool equalclause = _clause == other.clause;
      return equalname & equalclause;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return 'Id(clause ${_clause.toString()}, id:${id.toString()})';
  }
}

class I<T> {
  I(T id) : _id = id;

  final T _id;

  T get id => _id;

  @override
  bool operator ==(dynamic other) {
    if (other is I<List>) {
      // Lists
      print(other is I<List>);
      print(other.id is List);
      if (other.id is List && id is List) {
        if (other.id.length != (id as List).length) {
          return false;
        } else {
          int z = 0;
          return (id as List).fold(true, (bool acc, dynamic n) {
            bool ret = other.id[z] == n;
            z++;
            return ret && acc;
          });
        }
      } else {
        bool equalnames = _id == other._id;
        return equalnames;
      }
      // all others

    } else {
      return false;
    }
  }

  @override
  String toString() {
    return 'I(${id.toString()})';
  }
}

class V<T, U> implements Var<T, U> {
  V(U id) : _id = id;

  final U _id;

  @override
  U get id => _id;

  @override
  String toString() {
    return 'V(${id.toString()})';
  }
}

class Node {}

class Branch<T, U> extends Node implements Term<T, U> {
  Branch(U id, List<Termtype<T, U>> t)
      : _id = id,
        _termlist = t;
  final U _id;

  @override
  U get id => _id;

  final List<Termtype<T, U>> _termlist;

  @override
  List<Termtype<T, U>> get termlist => _termlist;

  @override
  String toString() {
    return 'Branch(id: ${id.toString()}, termlist: ${termlist})';
  }

  @override
  bool operator ==(dynamic other) {
    if (other is Branch<T, U>) {
      int tl = _termlist.length;
      int otl = other.termlist.length;

      // 1.
      bool equallengths = tl == otl;

      // 2.
      bool equalnames = _id == other._id;

      // 3.
      bool resultequallist = true;
      for (int i = 0; i < tl; i++) {
        bool equallist = _termlist[i] == other._termlist[i];
        resultequallist && equallist
            ? resultequallist = true
            : resultequallist = false;
      }

      // 1. + 2. + 3.
      return equallengths && equalnames && resultequallist;
    } else {
      return false;
    }
  }
}

void main() {
  // 1.

  UnificationR<String, Id> u2 = UnificationR<String, Id>();
  /*
  // List<Tupl<Id, Termtype<String, Id>>>
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
      []); // <Tupl<Id, Termtype<String, Id>>>
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
      []); // <Tupl<I<List<int>>, Termtype<String, I<List<int>>>>>

  print(res01);
  // 2.
  UnificationR<String, String> u = UnificationR<String, String>();

  List<Tupl<String, Termtype<String, String>>> res1 = u.unify(
    Var('a'),
    Var('a'),
    [], // <Tupl<String, Termtype<String, String>>>
  );

  List<Tupl<String, Termtype<String, String>>> res2 = u.unify(
    Var('a'),
    Var('b'),
    [], // <Tupl<String, Termtype<String, String>>>
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
