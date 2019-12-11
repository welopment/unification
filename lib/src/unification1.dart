import 'utils.dart';
import 'terms.dart';
export 'terms.dart';

// TODO:
// rename Tupl into Binding
// inform and mark Binding about origin of Termtype from different clauses.abstract
// replace Exceptions with Result

/// not trampolined version
/// without helper functions

class UnificationR<A, B> {
  /// Performs an Occurs Check and
  /// returns the result as bool.
  bool occurs(B id, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      B tid = t.id;
      return (id == tid);
    } else if (t is Term<A, B>) {
      List<Termtype<A, B>> s = t.termlist;
      return _exsts(s, id);
    } else {
      throw Exception('occurs: Unknown Termtype or null.');
    }
  }

  /// A helper fuction for  'occurs check '

  bool _exsts(List<Termtype<A, B>> l, B target) {
    if (l.isEmpty) {
      return (false);
    } else {
      Termtype<A, B> hl = l.first; // head of List
      List<Termtype<A, B>> tl = l.sublist(1); // tail of list

      bool right = _exsts(tl, target); // direct recursion
      bool left = occurs(target, hl); // indirect recursion
      return (left || right);
    }
  }

  ///  Performs a substitution.

  Termtype<A, B> _subst(Termtype<A, B> s, B x, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      if (x == t.id) {
        return (s);
      } else {
        return (t);
      }
    } else if (t is Term<A, B>) {
      B f = t.id;
      List<Termtype<A, B>> u = t.termlist;
      List<Termtype<A, B>> right = _mp(s, x, u);
      return Term<A, B>(f, right);
    } else {
      throw Exception('_subst: Unknown Termtype or null ');
    }
  }

  /// recursively runs through a list [l] of [Termtype]s given as last parameter

  List<Termtype<A, B>> _mp(Termtype<A, B> s, B x, List<Termtype<A, B>> l) {
    if (l.isEmpty) {
      return (<Termtype<A, B>>[]);
    } else {
      Termtype<A, B> lh = l.first; // head of list
      List<Termtype<A, B>> lt = l.sublist(1); // tails of list

      List<Termtype<A, B>> right = _mp(s, x, lt); // direct recursion

      // applies a substitution
      Termtype<A, B> left = _subst(s, x, lh); // indirect recursion

      // concatenates results to list
      List<Termtype<A, B>> res = [left];
      res.addAll(right);

      return res;
    }
  }

  /// Applies a substitution
  /// The list of substitutions [ths] of type List<Tupl<B, Termtype<A, B>>>  is given as first argument.
  /// One substitution is applied on the term [t] of type  Termtype<A, B> given as last argument.

  Termtype<A, B> _apply(List<Tupl<B, Termtype<A, B>>> ths, Termtype<A, B> t) {
    if (ths.isEmpty) {
      return (t);
    } else {
      Tupl<B, Termtype<A, B>> frst = ths.first;
      B x = frst.left;
      Termtype<A, B> u = frst.right;

      List<Tupl<B, Termtype<A, B>>> xs = ths.sublist(1);

      Termtype<A, B> apd = _apply(xs, t);

      if (apd is Term<A, B>) {
        assert(apd.id != null);
      }
      Termtype<A, B> right = _subst(u, x, apd);
      return right;
    }
  }

  /// Tries to unify two single Termtypes [s] and [t].
  /// Returns a list of substiturions of type List<Tupl<B, Termtype<A, B>>>.

  List<Tupl<B, Termtype<A, B>>> _unify_one(
      Termtype<A, B> s, Termtype<A, B> t, List<Tupl<B, Termtype<A, B>>> subs) {
    if (s == null || t == null) {
      throw Exception('_unify_one: One of the Termtypes is null.');

      // Case 1: Try to unify two variables.
    } else if (s is Var<A, B> && t is Var<A, B>) {
      B x = s.id;
      B y = t.id;

      if (x == y) {
        return subs; //<Tupl<B, Termtype<A, B>>>[]
      } else {
        return subs..add(Tupl<B, Termtype<A, B>>(x, t));
      }

      // Case 2: Try to unify two Terms.
    } else if (s is Term<A, B> && t is Term<A, B>) {
      B f = s.id;
      List<Termtype<A, B>> sl = s.termlist;

      B g = t.id;
      List<Termtype<A, B>> tl = t.termlist;
      // Tries to unify two terms, i.e. their term lists and their names.
      if ((f == g) && (sl.length == tl.length)) {
        List<Tupl<Termtype<A, B>, Termtype<A, B>>> zpd =
            zip<Termtype<A, B>, Tupl<Termtype<A, B>, Termtype<A, B>>>(
                sl, tl, (left, right) => Tupl(left, right));

        return unify(zpd, subs);
      } else {
        throw Exception('_unify_one: Not unifiable #1 ');
      }

      // Case 3: Try to unify a variable with a term.
    } else if (s is Var<A, B> && t is Term<A, B>) {
      B x = s.id;
      bool occursCheck = occurs(x, t); // true if occurs

      if (occursCheck) {
        throw Exception('_unify_one: Not unifiable, circularity.');
      } else {
        // new substitution is added to the list of substitutions.
        //List<Tupl<B, Termtype<A, B>>> right =
        subs.add(Tupl(x, t)); // TODO: switch back to "[Tupl(x, t)]"
        return subs; // TODO: switch back to "right"
      }

      // Case 4: Try to unify a term with a variable.
    } else if (s is Term<A, B> && t is Var<A, B>) {
      B x = t.id;
      bool occursCheck = occurs(x, s); // true if occurs

      if (occursCheck) {
        throw Exception('_unify_one: Not unifiable, circularity.');
      } else {
        // new substitution is added to the list of substitutions.
        //List<Tupl<B, Termtype<A, B>>> right =
        subs.add(Tupl(x, s)); // TODO: switch back to "[Tupl(x, t)]"
        return subs; // TODO: switch back to "right"
      }
      // return _unify_one(t, s);
    } else {
      throw Exception('_unify_one: Unknown Termtype or null.');
    }
  }

  /// Unifies a list of terms.
  /// Returns a list of substitutions.

  List<Tupl<B, Termtype<A, B>>> unify(
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> s,
      List<Tupl<B, Termtype<A, B>>> subs) {
    if (s.isEmpty) {
      return (<Tupl<B, Termtype<A, B>>>[]);
    } else {
      Termtype<A, B> x = s.first.left;
      Termtype<A, B> y = s.first.right;

      List<Tupl<Termtype<A, B>, Termtype<A, B>>> t =
          s.sublist(1); // tail of list
      // recursion on list of terms,
      // so, unification happens in reverse order
      List<Tupl<B, Termtype<A, B>>> t2 = unify(t, subs); // TODO: new subs?
      // t2 is substiturion, diese wird angewandt
      Termtype<A, B> left = _apply(t2, x);
      Termtype<A, B> right = _apply(t2, y);
      // unify one b one in reverse order,
      // returning when from recursion
      // rückgabe ist die liste der substitutionen.
      List<Tupl<B, Termtype<A, B>>> t1 = _unify_one(left, right, subs);
      // die bei der Rückkehr aus der Rekursion aneinander gehängt werden
      return t1 + t2;
    }
  }
}

class Result<A, B> {
  Result(bool uni, List<Tupl<B, Termtype<A, B>>> subs)
      : unifiable = uni,
        substitution = subs;
  List<Tupl<B, Termtype<A, B>>> substitution;
  bool unifiable;
}
