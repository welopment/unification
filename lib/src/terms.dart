part of unification;

///  terms
///

abstract class Termtype<T> {
  T _id;

  T get id => this._id;
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

  @override
  bool operator ==(dynamic other) {
    return this == other;
  }

  @override
  int get hashCode => this._id.hashCode;
}

///

class Term<T> extends Termtype<T> {
  Term(T i, List<Termtype> t)
      : assert(i != null),
        assert(t != null) {
    this._id = i;
    this._termlist = t;
  }

  List<Termtype> _termlist;
  List<Termtype> get termlist => this._termlist;

  @override
  String toString() {
    return "Term(${this.id.toString()}, ${this.termlist})";
  }
}

/// utility

class Tupl<L, R> {
  Tupl(left, right)
      : assert(left != null),
        assert(right != null) {
    if (left == null) {
      throw new Exception("Tupl: left is null");
    } else {
      this._left = left;
    }
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
}
