import 'package:unification/unification.dart';

//################################################
//##
//##
//## Identities
//##
//##
//################################################

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

  int get n => _id;
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

//################################################
//##
//##
//## Terms: V, Node, Branch,
//##
//##
//################################################

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
