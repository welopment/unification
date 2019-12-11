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
}

void main() {
  // 1.

  UnificationR<String, Id> u2 = UnificationR<String, Id>();

  List<Tupl<Id, Termtype<String, Id>>> res = u2.unify(
      <Tupl<Var<String, Id>, Var<String, Id>>>[]..add(
          Tupl<Var<String, Id>, Var<String, Id>>(
            Var(Id(1)),
            Var(Id(2)),
          ),
        ),
      <Tupl<Id, Termtype<String, Id>>>[]);
  print(res);

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
