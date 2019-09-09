import 'utils.dart';
import 'terms.dart';
export 'terms.dart';

/// not trampolined version
/// without helper functions


/// reusing unify_one in two branches Term Var -> Var Term

class UnificationR<A> {
  /// [occurs] occurs check
  /// gibt das ergebnis als bool zurück , nicht als Exception
  bool occurs(A x, Termtype<A> t) {
    if (t is Var<A>) {
      A y = t.id;
      return (x == y);
    } else if (t is Term<A>) {
      List<Termtype<A>> s = t.termlist;
      return _exsts(s, x);
    } else if (x == null || t == null) {
      throw new Exception("occurs: Variable name  or Termtype is null");
    } else {
      throw new Exception("occurs: Unknown Exception");
    }
  }

  /// [_exsts] exists helper fuction for "occurs check"

  bool _exsts(List<Termtype<A>> l, A target) {
    if (l.isEmpty) {
      // Liste ist null
      return (false);
    } else {
      Termtype<A> lh = l.first; // Head of LIst
      List<Termtype<A>> lt = l.sublist(1); // Rest/Tail of List

      bool right = _exsts(lt, target); // recursiv
      bool left = occurs(target, lh); // Abstieg in Schachtelung
      return (left || right);
    }
  }

  ///  [_subst] substitution

  Termtype<A> _subst(Termtype<A> s, A x, Termtype<A> t) {
    if (t is Var<A>) {
      if (x == t.id) {
        return (s);
      } else {
        return (t);
      }
    } else if (t is Term<A>) {
      A f = t.id;
      List<Termtype<A>> u = t.termlist;
      List<Termtype<A>> right = _mp(s, x, u);
      return new Term<A>(f, right);
    } else {
      throw new Exception("Subst: Unbehandelter Fall");
    }
  }

  ///

  List<Termtype<A>> _mp(Termtype<A> s, A x, List<Termtype<A>> l) {
    assert(l != null);
    if (l.isEmpty) {
      return (new List<Termtype<A>>());
    } else {
      Termtype<A> lh = l.first;
      List<Termtype<A>> lt = l.sublist(1);
      assert(lh != null);
      assert(lt != null);

      List<Termtype<A>> right = _mp(s, x, lt);

      Termtype<A> left = _subst(s, x, lh);

      List<Termtype<A>> res = [left];
      res.addAll(right);
      return res;
    }
  }

  /// apply substitution

  Termtype<A> _apply(List<Tupl<A, Termtype<A>>> ths, Termtype<A> z) {
    if (ths.isEmpty) {
      return (z);
    } else {
      Tupl<A, Termtype<A>> frst = ths.first;
      A x = frst.left;
      Termtype<A> u = frst.right;

      List<Tupl<A, Termtype<A>>> xs = ths.sublist(1);

      Termtype<A> apd = _apply(xs, z);

      if (apd is Term<A>) {
        assert(apd.id != null);
      }
      Termtype<A> right = _subst(u, x, apd);
      return right;
    }
  }

  /// [unify_one]: unify two ingle Termtypes, one by one

  List<Tupl<A, Termtype<A>>> _unify_one(Termtype<A> s, Termtype<A> t) {
    if (s == null || t == null) {
      throw new Exception("occurs: Termtype is null");
    } else if (s is Var<A> && t is Var<A>) {
      A x = s.id;
      A y = t.id;

      if (x == y) {
        return new List<Tupl<A, Termtype<A>>>();
      } else {
        return new List<Tupl<A, Termtype<A>>>()
          ..add(new Tupl<A, Termtype<A>>(x, t));
      }
    } else if (s is Term<A> && t is Term<A>) {
      A f = s.id;
      List<Termtype<A>> sc = s.termlist;

      A g = t.id;
      List<Termtype<A>> tc = t.termlist;

      if ((f == g) && (sc.length == tc.length)) {
        List<Tupl<Termtype<A>, Termtype<A>>> zpd =
            // zwei Eingabetypen , ein Ausgabetyp
            zip<Termtype<A>, Tupl<Termtype<A>, Termtype<A>>>(
                sc, tc, (left, right) => new Tupl(left, right));

        return unify(zpd);
      } else {
        throw new Exception("Not unifiable #1");
      }
    } else if (s is Var<A> && t is Term<A>) {
      A x = s.id;
      bool left = occurs(x, t);
      List<Tupl<A, Termtype<A>>> right = ([new Tupl(x, t)]);

      if (left) {
        throw new Exception("Not unifiable: Occurs check true / Circularity");
      } else {
        return right;
      }
    } else if (s is Term<A> && t is Var<A>) {
      // Wiederverwendung von Fall  s is Var<A> && t is Term<A> oben für die Umgekehrte Stellung
      return _unify_one(t, s);
    } else {
      throw new Exception("Not unifiable #2");
    }
  }

  /// [unify]: unify a list of terms

  List<Tupl<A, Termtype<A>>> unify(List<Tupl<Termtype<A>, Termtype<A>>> s) {
    if (s.isEmpty) {
      return (new List<Tupl<A, Termtype<A>>>());
    } else {
      Termtype<A> x = s.first.left;
      Termtype<A> y = s.first.right;
      List<Tupl<Termtype<A>, Termtype<A>>> t = s.sublist(1);
      List<Tupl<A, Termtype<A>>> t2 = unify(t);
      Termtype<A> left = _apply(t2, x);
      Termtype<A> right = _apply(t2, y);
      List<Tupl<A, Termtype<A>>> t1 = _unify_one(left, right);

      return t1 + t2;
    }
  }
}
