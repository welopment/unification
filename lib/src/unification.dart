import "package:tailcalls/tailcalls.dart";
import 'utils.dart';
import 'terms.dart';

export 'terms.dart';

/// diese ist unification mit trampoline
/// diese muß nach dem Vorbild von
/// der ohne trampoline, ggf der ohne helper
/// korrigiert werden

/// trampolined version

/// occurs check
class Unification<A> {
  TailRec<bool> occurs(A x, Termtype<A> t) {
    if (t is Var<A>) {
      A y = t.id;
      return done(x == y);
    } else if (t is Term<A>) {
      List<Termtype<A>> s = t.termlist;
      return tailcall(() => _exsts(s, x));
    } else if (x == null || t == null) {
      throw new Exception("occurs: Variable name or Term is null");
    } else {
      throw new Exception("Occurs Check: #1");
    }
  }

  /// helper fuction for occurs check

  TailRec<bool> _exsts(List<Termtype<A>> l, A target) {
    if (l.isEmpty) {
      return done(false);
    } else {
      Termtype<A> lh = l.first;
      List<Termtype<A>> lt = l.sublist(1);

      return tailcall(() => _exsts(lt, target)).flatMap((right) {
        return tailcall(() => occurs(target, lh)).map((left) {
          return (left || right);
        });
      });
    }
  }

  /// substitution

  TailRec<Termtype<A>> _subst(Termtype<A> s, A x, Termtype<A> t) {
    if (t is Var<A>) {
      if (x == t.id) {
        return done(s);
      } else {
        return done(t);
      }
    } else if (t is Term<A>) {
      A f = t.id;
      List<Termtype<A>> u = t.termlist;
      assert(!u.isNotEmpty);
      assert(u != null);
      return tailcall(() => _mp(s, x, u)).map((right) {
        return new Term<A>(/*t.i*/ f, right);
      });
    } else {
      throw new Exception("Substitution: #2");
    }
  }

  ///

  TailRec<List<Termtype<A>>> _mp(Termtype<A> s, A x, List<Termtype<A>> l) {
    assert(l != null);
    if (l.isEmpty) {
      return done<List<Termtype<A>>>(new List<Termtype<A>>());
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

  TailRec<Termtype<A>> _apply(List<Tupl<A, Termtype<A>>> ths, Termtype<A> z) {
    if (ths.isEmpty) {
      return done<Termtype<A>>(z);
    } else {
      // pop
      Tupl<A, Termtype<A>> first = ths.first;
      A x = first.left;
      Termtype<A> u = first.right;

      List<Tupl<A, Termtype<A>>> xs = ths.sublist(1);

      return tailcall(() => _apply(xs, z)).flatMap((Termtype<A> apd) {
        assert(apd != null);
        assert(apd.id != null);

        return tailcall(() => _subst(u, x, apd)).map((right) {
          return right;
        });
      });
    }
  }

  /// unifies two ingle Termtypes, one by one

  TailRec<List<Tupl<A, Termtype<A>>>> _unify_one(Termtype<A> s, Termtype<A> t) {
    if (s == null || t == null) {
      throw new Exception("Occurs Check: Termtype is null");
    } else if (s is Var<A> && t is Var<A>) {
      var x = s.id;
      var y = t.id;

      if (x == y) {
        return done<List<Tupl<A, Termtype<A>>>>(
            new List<Tupl<A, Termtype<A>>>());
      } else {
        return done<List<Tupl<A, Termtype<A>>>>(new List<Tupl<A, Termtype<A>>>()
          ..add(new Tupl<A, Termtype<A>>(x, t)));
      }
    } else if (s is Term<A> && t is Term<A>) {
      A f = s.id;
      List<Termtype<A>> sc = s.termlist;

      A g = t.id;
      List<Termtype<A>> tc = t.termlist;

      if ((f == g) && (sc.length == tc.length)) {
        List<Tupl<Termtype<A>, Termtype<A>>> zpd =
            zip<Termtype<A>, Tupl<Termtype<A>, Termtype<A>>>(
                sc,
                tc,
                (left, right) =>
                    new Tupl<Termtype<A>, Termtype<A>>(left, right));

        return tailcall(() => unifyTc(zpd));
      } else {
        throw new Exception("Not unifiable: #1");
      }
    } else if (s is Var<A> && t is Term<A>) {
      return _unifyhelper(t, s.id);
    } else if (s is Term<A> && t is Var<A>) {
      return _unifyhelper(s, t.id);
    } else {
      throw new Exception("Not unifiable: #2");
    }
  }

  /// helper function for [unify_one]

  TailRec<List<Tupl<A, Termtype<A>>>> _unifyhelper(Termtype<A> t, A x) {
    return tailcall(() => occurs(x, t)).flatMap((left) {
      return done([new Tupl(x, t)]).map((right) {
        List<Tupl<A, Termtype<A>>> innerres;
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

  TailRec<List<Tupl<A, Termtype<A>>>> unifyTc(
      List<Tupl<Termtype<A>, Termtype<A>>> s) {
    if (s.isEmpty) {
      return done<List<Tupl<A, Termtype<A>>>>(new List<Tupl<A, Termtype<A>>>());
    } else {
      Termtype<A> x = s.first.left;
      Termtype<A> y = s.first.right;
      List<Tupl<Termtype<A>, Termtype<A>>> t = s.sublist(1);

      assert(t != null);

      return tailcall(() => unifyTc(t)).flatMap((t2) {
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

  List<Tupl<A, Termtype<A>>> unify(List<Tupl<Termtype<A>, Termtype<A>>> s) {
    return unifyTc(s).result();
  }
}

void main() {
  var u = new Unification<String>();

  List<Tupl<String, Termtype<String>>> res2 =
      u.unify([Tupl(Var("a"), Var("b"))]);

  //print();
}

// Cont<Termtype<String>, List<Tupl<String, Termtype<String>>>>'
// Cont<List<Tupl<String, Termtype<String>>>, List<Tupl<String, Termtype<String>>>>'
