//part of unification;


import "package:tailcalls/tailcalls.dart";
import 'utils.dart';
import 'terms.dart';

export 'terms.dart';


/// trampolined version

/// occurs check

TailRec<bool> occurs(String x, Termtype t) {
  if (t is Var) {
    var y = t.id;
    return done(x == y);
  } else if (t is Term) {
    var s = t.termlist;
    return tailcall(() => _exsts(s, x));
  } else if (x == null || t == null) {
    throw new Exception("occurs: Variable name or Term is null");
  } else {
    throw new Exception("Occurs Check: #1");
  }
}

/// helper fuction for occurs check

TailRec<bool> _exsts(List<Termtype> l, String target) {
  if (l.isEmpty) {
    return done(false);
  } else {
    Termtype lh = l.first;
    List<Termtype> lt = l.sublist(1);

    return tailcall(() => _exsts(lt, target)).flatMap((right) {
      return tailcall(() => occurs(target, lh)).map((left) {
        return (left || right);
      });
    });
  }
}

/// substitution

TailRec<Termtype> _subst(Termtype s, String x, Termtype t) {
  if (t is Var) {
    if (x == t.id) {
      return done(s);
    } else {
      return done(t);
    }
  } else if (t is Term) {
    String f = t.id;
    List<Termtype> u = t.termlist;
    assert(!u.isNotEmpty);
    assert(u != null);
    return tailcall(() => _mp(s, x, u)).map((right) {
      return new Term(/*t.i*/ f, right);
    });
  } else {
    throw new Exception("Substitution: #2");
  }
}

///

TailRec<List<Termtype>> _mp(Termtype s, String x, List<Termtype> l) {
  assert(l != null);
  if (l.isEmpty) {
    return done<List<Termtype>>(new List<Termtype>());
  } else {
    var lh = l.first;
    var lt = l.sublist(1);
    assert(lh != null);
    assert(lt != null);
    return tailcall(() => _mp(s, x, lt)).flatMap((right) {
      assert(lh != null);
      return tailcall(() => _subst(s, x, lh)).map((left) {
        assert(right != null);
        assert(left != null);
        var res = [left];
        res.addAll(right);
        return res;
      });
    });
  }
}

/// apply substitution

TailRec<Termtype> _apply(List<Tupl<String, Termtype>> ths, Termtype z) {
  if (ths.isEmpty) {
    return done<Termtype>(z);
  } else {
    // pop
    Tupl<String, Termtype> first = ths.first;
    String x = first.left;
    Termtype u = first.right;

    var xs = ths.sublist(1);

    return tailcall(() => _apply(xs, z)).flatMap((Termtype apd) {
      assert(apd != null);
      assert(apd.id != null);

      return tailcall(() => _subst(u, x, apd)).map((right) {
        return right;
      });
    });
  }
}

/// unifies two ingle Termtypes, one by one

TailRec<List<Tupl<String, Termtype>>> _unify_one(Termtype s, Termtype t) {
  if (s == null || t == null) {
    throw new Exception("Occurs Check: Termtype is null");
  } else if (s is Var && t is Var) {
    var x = s.id;
    var y = t.id;

    if (x == y) {
      return done<List<Tupl<String, Termtype>>>(
          new List<Tupl<String, Termtype>>());
    } else {
      return done<List<Tupl<String, Termtype>>>(
          new List<Tupl<String, Termtype>>()
            ..add(new Tupl<String, Termtype>(x, t)));
    }
  } else if (s is Term && t is Term) {
    var f = s.id;
    var sc = s.termlist;

    var g = t.id;
    var tc = t.termlist;

    if ((f == g) && (sc.length == tc.length)) {
      List<Tupl<Termtype, Termtype>> zpd =
          zip<Termtype, Tupl<Termtype, Termtype>>(
              sc, tc, (left, right) => new Tupl(left, right));

      return tailcall(() => unify(zpd));
    } else {
      throw new Exception("Not unifiable: #1");
    }
  } else if (s is Var && t is Term) {
    return _unifyhelper(t, s.id);
  } else if (s is Term && t is Var) {
    return _unifyhelper(s, t.id);
  } else {
    throw new Exception("Not unifiable: #2");
  }
}

/// helper function for [unify_one]

TailRec<List<Tupl<String, Termtype>>> _unifyhelper(Termtype t, String x) {
  return tailcall(() => occurs(x, t)).flatMap((left) {
    return done([new Tupl(x, t)]).map((right) {
      List<Tupl<String, Termtype>> innerres;
      if (left) {
        throw new Exception("Not unifiable: Circularity");
      } else {
        innerres = right;
      }
      return innerres;
    });
  });
}

/// unify a list of terms

TailRec<List<Tupl<String, Termtype>>> unify(List<Tupl<Termtype, Termtype>> s) {
  if (s.isEmpty) {
    return done<List<Tupl<String, Termtype>>>(
        new List<Tupl<String, Termtype>>());
  } else {
    Termtype x = s.first.left;
    Termtype y = s.first.right;
    List<Tupl<Termtype, Termtype>> t = s.sublist(1);

    assert(t != null);

    return tailcall(() => unify(t)).flatMap((t2) {
      return tailcall(() => _apply(t2, x)).flatMap((left) {
        return tailcall(() => _apply(t2, y)).flatMap((right) {
          return tailcall(() => _unify_one(left, right)).map((t1) {
            assert(t1 != null);
            assert(t2 != null);
            t1.addAll(t2);
            return t1;
          });
        });
      });
    });
  }
}

