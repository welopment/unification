import 'package:tailcalls/tailcalls.dart';
//import  'package:trampoline/trampoline.dart ';
import 'utils.dart';
import 'terms.dart';
export 'terms.dart';

/// trampolined version
///
class Unification<A, B> {
  /// occurs check
  TailRec<bool> occurs(A x, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      A y = t.id;
      return done(x == y);
    } else if (t is Term<B, A>) {
      List<Termtype<A, B>> s = t.termlist;
      return tailcall(() => _exsts(s, x));
    } else if (x == null || t == null) {
      throw Exception( 'occurs: Variable name or Term is null ');
    } else {
      throw Exception( 'Occurs Check: #1 ');
    }
  }

  /// helper fuction for occurs check

  TailRec<bool> _exsts(List<Termtype<A, B>> l, A target) {
    if (l.isEmpty) {
      return done(false);
    } else {
      Termtype<A, B> lh = l.first;
      List<Termtype<A, B>> lt = l.sublist(1);
      return tailcall(() => _exsts(lt, target)).flatMap((right) {
        return tailcall(() => occurs(target, lh)).map((left) {
          return (left || right);
        });
      });
    }
  }

  /// [_subst] substitution

  TailRec<Termtype<A, B>> _subst(Termtype<A, B> s, A x, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      if (x == t.id) {
        return done(s);
      } else {
        return done(t);
      }
    } else if (t is Term<B, A>) {
      B f = t.id;
      List<Termtype<A, B>> u = t.termlist;
      return tailcall(() => _mp(s, x, u)).map((right) {
        return Term<B, A>(f, right);
      });
    } else {
      throw Exception( 'Substitution: #2 ');
    }
  }

  /// [_mp] is a helper function for Lists of terms

  TailRec<List<Termtype<A, B>>> _mp(
      Termtype<A, B> s, A x, List<Termtype<A, B>> l) {
    assert(l != null);
    if (l.isEmpty) {
      return done<List<Termtype<A, B>>>(List<Termtype<A, B>>());
    } else {
      var lh = l.first;
      var lt = l.sublist(1);
      return tailcall(() => _mp(s, x, lt)).flatMap((right) {
        return tailcall(() => _subst(s, x, lh)).map((left) {
          var res = [left];
          res.addAll(right);
          return res;
        });
      });
    }
  }

  /// [_apply] applies substitution

  TailRec<Termtype<A, B>> _apply(
      List<Tupl<A, Termtype<A, B>>> ths, Termtype<A, B> z) {
    if (ths.isEmpty) {
      return done<Termtype<A, B>>(z);
    } else {
      Tupl<A, Termtype<A, B>> first = ths.first;
      A x = first.left;
      Termtype<A, B> u = first.right;
      List<Tupl<A, Termtype<A, B>>> xs = ths.sublist(1);
      return tailcall(() => _apply(xs, z)).flatMap((Termtype<A, B> apd) {
        return tailcall(() => _subst(u, x, apd)).map((right) {
          return right;
        });
      });
    }
  }

  /// [_unify_one] unifies two ingle Termtypes, one by one

  TailRec<List<Tupl<A, Termtype<A, B>>>> _unify_one(
      Termtype<A, B> s, Termtype<A, B> t) {
    if (s == null || t == null) {
      throw Exception( 'Occurs Check: Termtype is null ');
    } else if (s is Var<A, B> && t is Var<A, B>) {
      var x = s.id;
      var y = t.id;

      if (x == y) {
        return done<List<Tupl<A, Termtype<A, B>>>>(
            List<Tupl<A, Termtype<A, B>>>());
      } else {
        return done<List<Tupl<A, Termtype<A, B>>>>(
            List<Tupl<A, Termtype<A, B>>>()
              ..add(Tupl<A, Termtype<A, B>>(x, t)));
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
        return tailcall(() => unifyTc(zpd));
      } else {
        throw Exception( 'Not unifiable: #1 ');
      }
    } else if (s is Var<A, B> && t is Term<B, A>) {
      return _unifyhelper(t, s.id);
    } else if (s is Term<B, A> && t is Var<A, B>) {
      return _unifyhelper(s, t.id);
    } else {
      throw Exception( 'Not unifiable: #2 ');
    }
  }

  /// [_unifyhelper] helper function for [unify_one]

  TailRec<List<Tupl<A, Termtype<A, B>>>> _unifyhelper(Termtype<A, B> t, A x) {
    return tailcall(() => occurs(x, t)).flatMap((left) {
      return done([Tupl(x, t)]).map((right) {
        List<Tupl<A, Termtype<A, B>>> innerres;
        if (left) {
          throw Exception( 'Not unifiable: Circularity ');
        } else {
          innerres = right;
        }
        return innerres;
      });
    });
  }

  /// unify a list of terms

  TailRec<List<Tupl<A, Termtype<A, B>>>> unifyTc(
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> s) {
    if (s.isEmpty) {
      return done<List<Tupl<A, Termtype<A, B>>>>(
          <Tupl<A, Termtype<A, B>>>[]);
    } else {
      Termtype<A, B> x = s.first.left;
      Termtype<A, B> y = s.first.right;
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> t = s.sublist(1);
      return tailcall(() => unifyTc(t)).flatMap((t2) {
        return tailcall(() => _apply(t2, x)).flatMap((left) {
          return tailcall(() => _apply(t2, y)).flatMap((right) {
            return tailcall(() => _unify_one(left, right)).map((t1) {
              t1.addAll(t2);
              return t1;
            });
          });
        });
      });
    }
  }

  List<Tupl<A, Termtype<A, B>>> unify(
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> s) {
    return unifyTc(s).result();
  }
}

void main() {
  Unification<String, String> u = Unification<String, String>();

  List<Tupl<String, Termtype<String, String>>> res =
      u.unify([Tupl(Var( 'a '), Var( 'b '))]);

  print( 'Result  ${res} ');
}
