import 'utils.dart';
import 'terms.dart';
export 'terms.dart';

/// not trampolined version
/// with helpers

/// occurs check
class UnificationH<A, B> {
  bool occurs(A x, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      A y = t.id;
      return (x == y);
    } else if (t is Term<B, A>) {
      List<Termtype<A, B>> s = t.termlist;
      return _exsts(s, x);
    } else if (x == null || t == null) {
      throw Exception( 'occurs: Variable name  or Termtype is null ');
    } else {
      throw Exception( 'occurs: Unknown Exception ');
    }
  }

  /// helper fuction for occurs check

  bool _exsts(List<Termtype<A, B>> l, A target) {
    if (l.isEmpty) {
      return (false);
    } else {
      var lh = l.first;
      List<Termtype<A, B>> lt = l.sublist(1);
      bool right = _exsts(lt, target);
      bool left = occurs(target, lh);
      return (left || right);
    }
  }

  /// substitution

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
      return Term<B, A>(f, right);
    } else {
      throw Exception( 'Subst: Unbehandelter Fall ');
    }
  }

  ///

  List<Termtype<A, B>> _mp(Termtype<A, B> s, A x, List<Termtype<A, B>> l) {
    assert(l != null);
    if (l.isEmpty) {
      return (<Termtype<A, B>>[]);
    } else {
      var lh = l.first;
      var lt = l.sublist(1);
      var right = _mp(s, x, lt);
      var left = _subst(s, x, lh);
      var res = [left];
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

  ///  unify two ingle Termtypes, one by one

  List<Tupl<A, Termtype<A, B>>> _unify_one(Termtype<A, B> s, Termtype<A, B> t) {
    if (s == null || t == null) {
      throw Exception( 'occurs: Termtype is null ');
    } else if (s is Var<A, B> && t is Var<A, B>) {
      var x = s.id;
      var y = t.id;

      if (x == y) {
        return List<Tupl<A, Termtype<A, B>>>();
      } else {
        return List<Tupl<A, Termtype<A, B>>>()
          ..add(Tupl<A, Termtype<A, B>>(x, t));
      }
    } else if (s is Term<B, A> && t is Term<B, A>) {
      B f = s.id;
      List<Termtype<A, B>> sc = s.termlist;

      B g = t.id;
      List<Termtype<A, B>> tc = t.termlist;

      if ((f == g) && (sc.length == tc.length)) {
        List<Tupl<Termtype<A, B>, Termtype<A, B>>> zpd =
            zip<Termtype<A, B>, Tupl<Termtype<A, B>, Termtype<A, B>>>(
                sc,
                tc,
                (left, right) =>
                    Tupl<Termtype<A, B>, Termtype<A, B>>(left, right));

        return unify(zpd);
      } else {
        throw Exception( 'Not unifiable #1 ');
      }
    } else if (s is Var<A, B> && t is Term<B, A>) {
      return _unifyhelper(t, s.id);
    } else if (s is Term<B, A> && t is Var<A, B>) {
      return _unifyhelper(s, t.id);
    } else {
      throw Exception( 'Not unifiable #2 ');
    }
  }

  ///helper function for unify_one

  List<Tupl<A, Termtype<A, B>>> _unifyhelper(Termtype<A, B> t, A x) {
    bool left = occurs(x, t);
    List<Tupl<A, Termtype<A, B>>> right = ([Tupl(x, t)]);
    List<Tupl<A, Termtype<A, B>>> innerres;

    if (left) {
      throw Exception( 'not unifiable: circularity ');
    } else {
      innerres = right;
    }

    return innerres;
  }

  /// unify a list of terms

  List<Tupl<A, Termtype<A, B>>> unify(
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> s) {
    if (s.isEmpty) {
      return (List<Tupl<A, Termtype<A, B>>>());
    } else {
      Termtype<A, B> x = s.first.left;
      Termtype<A, B> y = s.first.right;
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> t = s.sublist(1);
      List<Tupl<A, Termtype<A, B>>> t2 = unify(t);
      Termtype<A, B> left = _apply(t2, x);
      Termtype<A, B> right = _apply(t2, y);
      List<Tupl<A, Termtype<A, B>>> t1 = _unify_one(left, right);

      t1.addAll(t2);
      return t1;
    }
  }
}
