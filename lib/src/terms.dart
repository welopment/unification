//part of unification;

///  terms
///

abstract class Termtype<T, U> {
}

/// T ist der Name der Variablen, U ist ungenutzt, der Wert, der zugewiesen wird. 

class Var<T, U> extends Termtype<T, U> {
  Var(T i)  {
    this._id = i;
  }
 T _id;

  T get id => this._id;

  @override
  String toString() {
    return "Var(${this.id.toString()})";
  }



  @override
  int get hashCode => this._id.hashCode;
}

/// Var("a"), Term("F", [Var("a"), Var("b")])    F(a, b)
/// U ist der Nutzwert des Terms, T ist der Name, eher ungenutzt . 
/// T ist der Name der Variablen, U ist ungenutzt, der Nutzwert, der zugewiesen wird. 

class Term<U, T> extends Termtype<T, U> {
  Term(U i, List<Termtype<T, U>> t, { T  name})
      {
    this._id = i;
    this._termlist = t;
  }
  U _id;

  U get id => this._id;

  List<Termtype<T, U>> _termlist;
  List<Termtype<T, U>> get termlist => this._termlist;

  @override
  String toString() {
    return "Term(${this.id.toString()}, ${this.termlist})";
  }

  @override
  bool operator ==(dynamic other) {
    // better solution
    if (other is Term<T, U> || other is Var<T,U>) {
      return this._id == other._id;
    } else {
      return false;
    }
  }
}

/// utility

class Tupl<L, R> {
  Tupl(L left, R right)
      {
    /// Remove
    if (left == null) {
      throw new Exception("Tupl: left is null");
    } else {
      this._left = left;
    }

    /// Remove
    if (right == null) {
      throw new Exception("Tupl: right is null");
    } else {
      this._right = right;
    }
  }
  L _left;
  R _right;
  L get left => this._left;
  R get right => this._right;

  @override
  String toString() {
    return "(${left.toString()}, ${right.toString()})";
  }

  @override
  bool operator ==(dynamic other) {
    if (other is Tupl<L, R>) {
      return this._left == other._left && this._right == other._right;
    } else {
      return false;
    }
  }
}
