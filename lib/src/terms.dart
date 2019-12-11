/// The super class, from which Term and Var are derived
abstract class Termtype<T, U> {
  Termtype(U id) : _id = id;
  final U _id;

  U get id;

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString();
}

/// T ist der Name der Variablen, U ist ungenutzt, der Wert, der zugewiesen wird.

class Var<T, U> implements Termtype<T, U> {
  Var(U id) : _id = id
  /*, super(i)*/
  ;

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

/// Term('f', [Var('A'), Var('B')])    f(A, B)
/// T ist der Nutzwert des Terms, U ist der Name, eher ungenutzt .
/// U ist der Name der Variablen, T ist ungenutzt, der Nutzwert, der zugewiesen wird.

class Term<T, U> implements Termtype<T, U> {
  Term(U id, List<Termtype<T, U>> t)
      : _id = id,
        _termlist = t
  /*, super(i)*/
  ;
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

/// utility

class Tupl<L, R> {
  Tupl(L left, R right)
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
    if (other is Tupl<L, R>) {
      return _left == other._left && _right == other._right;
    } else {
      return false;
    }
  }
}
