//part of unification;

///  terms
///

abstract class Termtype<T, U> {}

/// T ist der Name der Variablen, U ist ungenutzt, der Wert, der zugewiesen wird.

class Var<T, U> extends Termtype<T, U> {
  Var(T i) : _id = i;
  final T _id;

  T get id => _id;

  @override
  String toString() {
    return 'Var(${id.toString()})';
  }

  @override
  int get hashCode => _id.hashCode;
}

/// Var('a'), Term('F', [Var('a'), Var('b')])    F(a, b)
/// U ist der Nutzwert des Terms, T ist der Name, eher ungenutzt .
/// T ist der Name der Variablen, U ist ungenutzt, der Nutzwert, der zugewiesen wird.

class Term<U, T> extends Termtype<T, U> {
  Term(U i, List<Termtype<T, U>> t, {T? name})
      :  _id = i,
         _termlist = t;
  final U _id;

  U get id =>  _id;

  final List<Termtype<T, U>> _termlist;
  List<Termtype<T, U>> get termlist =>  _termlist;

  @override
  String toString() {
    return 'Term(${ id.toString()}, ${ termlist})';
  }

  @override
  bool operator ==(dynamic other) {
    // better solution
    if (other is Term<T, U> || other is Var<T, U>) {
      return  _id == other._id;
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
  R get right =>  _right;

  @override
  String toString() {
    return '(${left.toString()}, ${right.toString()})';
  }

  @override
  bool operator ==(dynamic other) {
    if (other is Tupl<L, R>) {
      return  _left == other._left &&  _right == other._right;
    } else {
      return false;
    }
  }
}
