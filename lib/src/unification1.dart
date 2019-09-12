import 'utils.dart';
import 'terms.dart';
export 'terms.dart';

/// not trampolined version
/// without helper functions

/// reusing unify_one in two branches Term Var -> Var Term
/// B ist der Nutzwert des Terms, A ist der Name, eher ungenutzt .
/// A ist der Name der Variablen, B ist ungenutzt, der Nutzwert, der zugewiesen wird.

class UnificationR<A, B> {
  /// [occurs] occurs check
  /// gibt das ergebnis als bool zurück , nicht als Exception
  bool occurs(A x, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      A y = t.id;
      return (x == y);
    } else if (t is Term<B, A>) {
      List<Termtype<A, B>> s = t.termlist;
      return _exsts(s, x);
    } else if (x == null || t == null) {
      throw new Exception("occurs: Variable name  or Termtype is null");
    } else {
      throw new Exception("occurs: Unknown Exception");
    }
  }

  /// [_exsts] exists helper fuction for "occurs check"

  bool _exsts(List<Termtype<A, B>> l, A target) {
    if (l.isEmpty) {
      // Liste ist null
      return (false);
    } else {
      Termtype<A, B> lh = l.first; // Head of LIst
      List<Termtype<A, B>> lt = l.sublist(1); // Rest/Tail of List

      bool right = _exsts(lt, target); // recursiv
      bool left = occurs(target, lh); // Abstieg in Schachtelung
      return (left || right);
    }
  }

  ///  [_subst] substitution

  Termtype<A, B> _subst(Termtype<A, B> s, A x, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      if (x == t.id) {
        return (s);
      } else {
        return (t);
      }
    } else if (t is Term<B, A>) {
      B f = t.id;
      List<Termtype<A, B>> u = t.termlist;
      List<Termtype<A, B>> right = _mp(s, x, u);
      return new Term<B, A>(f, right);
    } else {
      throw new Exception("Subst: Unbehandelter Fall");
    }
  }

  ///

  List<Termtype<A, B>> _mp(Termtype<A, B> s, A x, List<Termtype<A, B>> l) {
    assert(l != null);
    if (l.isEmpty) {
      return (new List<Termtype<A, B>>());
    } else {
      Termtype<A, B> lh = l.first;
      List<Termtype<A, B>> lt = l.sublist(1);
      assert(lh != null);
      assert(lt != null);

      List<Termtype<A, B>> right = _mp(s, x, lt);

      Termtype<A, B> left = _subst(s, x, lh);

      List<Termtype<A, B>> res = [left];
      res.addAll(right);
      return res;
    }
  }

  /// apply substitution

  Termtype<A, B> _apply(List<Tupl<A, Termtype<A, B>>> ths, Termtype<A, B> z) {
    if (ths.isEmpty) {
      return (z);
    } else {
      Tupl<A, Termtype<A, B>> frst = ths.first;
      A x = frst.left;
      Termtype<A, B> u = frst.right;

      List<Tupl<A, Termtype<A, B>>> xs = ths.sublist(1);

      Termtype<A, B> apd = _apply(xs, z);

      if (apd is Term<B, A>) {
        assert(apd.id != null);
      }
      Termtype<A, B> right = _subst(u, x, apd);
      return right;
    }
  }

  /// [unify_one]: unify two ingle Termtypes, one by one

  List<Tupl<A, Termtype<A, B>>> _unify_one(Termtype<A, B> s, Termtype<A, B> t) {
    if (s == null || t == null) {
      throw new Exception("occurs: Termtype is null");
    } else if (s is Var<A, B> && t is Var<A, B>) {
      A x = s.id;
      A y = t.id;

      if (x == y) {
        return new List<Tupl<A, Termtype<A, B>>>();
      } else {
        return new List<Tupl<A, Termtype<A, B>>>()
          ..add(new Tupl<A, Termtype<A, B>>(x, t));
      }
    } else if (s is Term<B, A> && t is Term<B, A>) {
      B f = s.id;
      List<Termtype<A, B>> sc = s.termlist;

      B g = t.id;
      List<Termtype<A, B>> tc = t.termlist;

      if ((f == g) && (sc.length == tc.length)) {
        List<Tupl<Termtype<A, B>, Termtype<A, B>>> zpd =
            // zwei Eingabetypen , ein Ausgabetyp
            zip<Termtype<A, B>, Tupl<Termtype<A, B>, Termtype<A, B>>>(
                sc, tc, (left, right) => new Tupl(left, right));

        return unify(zpd);
      } else {
        throw new Exception("Not unifiable #1");
      }
    } else if (s is Var<A, B> && t is Term<B, A>) {
      A x = s.id;
      bool left = occurs(x, t);
      List<Tupl<A, Termtype<A, B>>> right = ([new Tupl(x, t)]);

      if (left) {
        throw new Exception("Not unifiable: Occurs check true / Circularity");
      } else {
        return right;
      }
    } else if (s is Term<B, A> && t is Var<A, B>) {
      // Wiederverwendung von Fall  s is Var<A,B>  && t is Term<B,A>   oben für die Umgekehrte Stellung
      return _unify_one(t, s);
    } else {
      throw new Exception("Not unifiable #2");
    }
  }

  /// [unify]: unify a list of terms

  List<Tupl<A, Termtype<A, B>>> unify(
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> s) {
    if (s.isEmpty) {
      return (new List<Tupl<A, Termtype<A, B>>>());
    } else {
      Termtype<A, B> x = s.first.left;
      Termtype<A, B> y = s.first.right;
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> t = s.sublist(1);
      List<Tupl<A, Termtype<A, B>>> t2 = unify(t);
      Termtype<A, B> left = _apply(t2, x);
      Termtype<A, B> right = _apply(t2, y);
      List<Tupl<A, Termtype<A, B>>> t1 = _unify_one(left, right);

      return t1 + t2;
    }
  }
}
