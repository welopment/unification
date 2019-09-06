//part of unification;

///  terms
///

abstract class Termtype<T> {
  T _id;

  T get id => this._id;
  /*
  @override
  bool operator ==(dynamic other) {
    if (other is Termtype<T>) {
      return this._id == other._id;
    } else {
      return false;
    }
  }
  */
}

///

class Var<T> extends Termtype<T> {
  Var(T i) : assert(i != null) {
    this._id = i;
  }

  @override
  String toString() {
    return "Var(${this.id.toString()})";
  }

/*
  @override
  bool operator ==(dynamic other) {
    if (other is Termtype<T>) {
      return this._id == other._id;
    } else {
      return false;
    }


  }
*/
  @override
  int get hashCode => this._id.hashCode;
}

///

class Term<T> extends Termtype<T> {
  Term(T i, List<Termtype<T>> t)
      : assert(i != null),
        assert(t != null) {
    this._id = i;
    this._termlist = t;
  }

  List<Termtype<T>> _termlist;
  List<Termtype<T>> get termlist => this._termlist;

  @override
  String toString() {
    return "Term(${this.id.toString()}, ${this.termlist})";
  }
  /*
  @override
  bool operator ==(dynamic other) {
    if (other is Termtype<T>) {
      return this._id == other._id;
    } else {
      return false;
    }
  }
  */
}

/// utility

class Tupl<L, R> {
  Tupl(L left, R right)
      : assert(left != null),
        assert(right != null) {
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
  /*
  @override
  bool operator ==(dynamic other) {
    if (other is Tupl<L, R>) {
      return this._left == other._left && this._right == other._right;
    } else {
      return false;
    }
  }
  */
}
