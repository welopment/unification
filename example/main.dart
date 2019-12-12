import 'package:unification/src/terms.dart';
import 'package:unification/unification.dart';
import 'dart:collection';

class Id {
  Id(int id) : _id = id;

  final int _id;

  int get id => _id;

  @override
  bool operator ==(dynamic other) {
    if (other is Id) {
      bool equalnames = _id == other._id;
      return equalnames;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return 'Id(${id.toString()})';
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

  List<Tupl<Id, Termtype<String, Id>>> res = u2.unify(
      <Tupl<Termtype<String, Id>, Var<String, Id>>>[]..add(
          Tupl<Termtype<String, Id>, Var<String, Id>>(
            Branch<String, Id>(Id(1), [
              Term(Id(3), [
                Branch<String, Id>(Id(4), [
                  V(
                    Id(5),
                  )
                ])
              ])
            ]),
            Var(Id(2)),
          ),
        ),
      <Tupl<Id, Termtype<String, Id>>>[]);
  print(res);

  // simplified:
  var res0 = u2.unify([
    Tupl(
        Term(Id(1), [
          Branch(Id(1), [
            Term(Id(3), [
              V(
                Id(4),
              ),
            ]),
          ]),
        ]),
        Var(Id(2))),
  ], []);
  print(res0);

  // 2.
  UnificationR<String, String> u = UnificationR<String, String>();

  List<Tupl<String, Termtype<String, String>>> res1 = u.unify(
      <Tupl<Var<String, String>, Var<String, String>>>[]..add(
          Tupl<Var<String, String>, Var<String, String>>(
            Var('a'),
            Var('a'),
          ),
        ),
      <Tupl<String, Termtype<String, String>>>[]);

  List<Tupl<String, Termtype<String, String>>> res2 = u.unify(
      <Tupl<Var<String, String>, Var<String, String>>>[]..add(
          Tupl(
            Var('a'),
            Var('b'),
          ),
        ),
      <Tupl<String, Termtype<String, String>>>[]);

  print(res1);
  print(res2);
}
