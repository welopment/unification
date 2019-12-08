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
      throw Exception( 'occurs: Variable name  or Termtype is null ');
    } else {
      throw Exception( 'occurs: Unknown Exception ');
    }
  }

  /// [_exsts] exists helper fuction for  'occurs check '

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
      return Term<B, A>(f, right);
    } else {
      throw Exception( 'Subst: Unbehandelter Fall ');
    }
  }

  /// Wendet die substitution an
  /// Ist teil einer doppelten Iteration, die recursiv geschrieben ist.
  /// recursives Durchlaufen eine Liste
  /// diese wird als letztes Argument List<Termtype<A, B>> l
  /// gegeben.

  List<Termtype<A, B>> _mp(Termtype<A, B> s, A x, List<Termtype<A, B>> l) {
    if (l.isEmpty) {
      return (<Termtype<A, B>>[]);
    } else {
      Termtype<A, B> lh = l.first;
      List<Termtype<A, B>> lt = l.sublist(1);

      List<Termtype<A, B>> right = _mp(s, x, lt);

      // die Substitution wird angewandt.
      Termtype<A, B> left = _subst(s, x, lh);

      List<Termtype<A, B>> res = [left];
      res.addAll(right);
      return res;
    }
  }

  /// apply substitution
  /// Die Liste der substitutionen ist in
  /// List<Tupl<A, Termtype<A, B>>> ths
  /// diese wird angewandt auf einen einzelnen Term
  /// Termtype<A, B> z
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
  /// der Rückgabewert ist eine Liste, List<Tupl<A, Termtype<A, B>>>
  /// das ist die DB der Substitutionen

  List<Tupl<A, Termtype<A, B>>> _unify_one(Termtype<A, B> s, Termtype<A, B> t) {
    if (s == null || t == null) {
      throw Exception( 'occurs: Termtype is null ');
      // Zwei Variablen
    } else if (s is Var<A, B> && t is Var<A, B>) {
      var x = s.id;
      var y = t.id;

      if (x == y) {
        return <Tupl<A, Termtype<A, B>>>[];
      } else {
        return <Tupl<A, Termtype<A, B>>>[]
          ..add(Tupl<A, Termtype<A, B>>(x, t));
      }
      // Zwei Terme
    } else if (s is Term<B, A> && t is Term<B, A>) {
      B f = s.id;
      List<Termtype<A, B>> sc = s.termlist;

      B g = t.id;
      List<Termtype<A, B>> tc = t.termlist;
      // die Listen innerhalb jeweils eines Terms werden unifiziert.
      // das reicht aber nicht. Die id und der Name müssen unifiziert werden
      if ((f == g) && (sc.length == tc.length)) {
        List<Tupl<Termtype<A, B>, Termtype<A, B>>> zpd =
            // zwei Eingabetypen , ein Ausgabetyp
            zip<Termtype<A, B>, Tupl<Termtype<A, B>, Termtype<A, B>>>(
                sc, tc, (left, right) => Tupl(left, right));

        return unify(zpd);
      } else {
        throw Exception( 'Not unifiable #1 ');
      }
    } else if (s is Var<A, B> && t is Term<B, A>) {
      A x = s.id;
      bool left = occurs(x, t); // true if occurs
      // eine neue Belegung wird hergestellt.
      List<Tupl<A, Termtype<A, B>>> right = ([Tupl(x, t)]);

      if (left) {
        throw Exception( 'Not unifiable: Occurs check true / Circularity ');
      } else {
        return right;
      }
    } else if (s is Term<B, A> && t is Var<A, B>) {
      // Wiederverwendung des vorausgehenden Falls, nämlich
      //  s is Var<A,B>  && t is Term<B,A>    für die Umgekehrte Stellung
      // sollte ersetzt werden.
      return _unify_one(t, s);
    } else {
      throw Exception( 'Not unifiable #2 ');
    }
  }

  /// [unify]: unify a list of terms
  // rückgabe ist die liste der substitutionen,
  // die bei der Rückkehr aus der Rekursion aneinander gehängt werden

  List<Tupl<A, Termtype<A, B>>> unify(
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> s) {
    if (s.isEmpty) {
      return (<Tupl<A, Termtype<A, B>>>[]);
    } else {
      Termtype<A, B> x = s.first.left;
      Termtype<A, B> y = s.first.right;
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> t = s.sublist(1);
      // recursion on list of terms,
      // so, unification happens in reverse order
      List<Tupl<A, Termtype<A, B>>> t2 = unify(t);
      // t2 is substiturion, diese wird angewandt
      Termtype<A, B> left = _apply(t2, x);
      Termtype<A, B> right = _apply(t2, y);
      // unify one b one in reverse order,
      // returning when from recursion
      // rückgabe ist die liste der substitutionen.
      List<Tupl<A, Termtype<A, B>>> t1 = _unify_one(left, right);
      // die bei der Rückkehr aus der Rekursion aneinander gehängt werden
      return t1 + t2;
    }
  }
}
