//################################################
//##
//##
//## Termtype
//##
//##
//################################################

/// The super class, from which Term and Var are derived
abstract class Termtype<T, U> {
  Termtype(U id) : _id = id;

  final U _id;

  U get id;

  @override
  String toString();

  @override
  int get hashCode => _id.hashCode;
}

//################################################
//##
//##
//## Var
//##
//##
//################################################

/// T ist der Name der Variablen, U ist ungenutzt, der Wert, der zugewiesen wird.

class Var<T, U> implements Termtype<T, U> {
  Var(U id) : _id = id;

  @override
  final U _id;

  @override
  U get id => _id;

  @override
  bool operator ==(dynamic other) {
    if (other is Var<T, U>) {
      bool equalnames = _id == other._id;
      return equalnames;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return 'Var(id: ${id.toString()})';
  }

  @override
  int get hashCode => _id.hashCode;
}

//################################################
//##
//##
//## Term
//##
//##
//################################################

/// Term('f', [Var('A'), Var('B')])    f(A, B)
/// T ist der Nutzwert des Terms, U ist der Name, eher ungenutzt .
/// U ist der Name der Variablen, T ist ungenutzt, der Nutzwert, der zugewiesen wird.

class Term<T, U> implements Termtype<T, U> {
  Term(U id, List<Termtype<T, U>> t)
      : _id = id,
        _termlist = t;

  @override
  final U _id;

  @override
  U get id => _id;

  final List<Termtype<T, U>> _termlist;
  List<Termtype<T, U>> get termlist => _termlist;

  @override
  String toString() {
    return 'Term(id: ${id.toString()}, termlist: ${termlist})';
  }

  @override
  int get hashCode => _id.hashCode;
  @override
  bool operator ==(dynamic other) {
    if (other is Term<T, U>) {
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

//################################################
//##
//##
//## Tuple
//##
//##
//################################################

class Tuple<L, R> {
  Tuple(L left, R right)
      : _left = left,
        _right = right;
  final L _left;
  final R _right;
  L get left => _left;
  R get right => _right;

  @override
  String toString() {
    return '(${left.toString()}, ${right.toString()})';
  }

  @override
  bool operator ==(dynamic other) {
    if (other is Tuple<L, R>) {
      return _left == other._left && _right == other._right;
    } else {
      return false;
    }
  }
}

//################################################
//##
//##
//## Identity
//##
//##
//################################################

class Identity {
  Identity(int clause, int id)
      : _id = id,
        _clause = clause {
    _unique++;
    _uni = _unique;
  }
  int _uni = -1;
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
  int get unique => _uni;

  @override
  int get hashCode => _uni;

  bool identical(dynamic other) {
    bool equal = hashCode == other.hashCode;
    return equal;
  }

  bool equal(dynamic other) {
    return this == other;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is Identity) {
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

//################################################
//##
//##
//## Id
//##
//##
//################################################

class Id extends Identity {
  Id(int clause, int id) : super(clause, id);
  dynamic bound;

  @override
  String toString() {
    return '${_clause.toString()}.${id.toString()}';
  }
}

//########################################################
//########################################################
//########################################################
//########################################################
