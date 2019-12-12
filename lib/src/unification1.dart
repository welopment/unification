import 'utils.dart';
import 'terms.dart';
export 'terms.dart';

// TODO:
// rename Tupl
// origin of Termtype
// replace Exceptions with Result

/// not trampolined version
/// without helper functions

class UnificationR<A, B> {
  //#######################################################
  //###
  //###   Occurs Check: occurs, _exsts
  //###
  //#######################################################

  /// Performs an occurs check and returns the result as bool.

  bool occurs(B id, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      B tid = t.id;
      // case 1: identical variables
      return (id == tid);
    } else if (t is Term<A, B>) {
      List<Termtype<A, B>> s = t.termlist;
      return _exsts(s, id);
    } else {
      throw Exception('occurs: Unknown Termtype or null.');
    }
  }

  /// A helper fuction for occurs check responsible for checking terms.
  /// It checks if the target variable represented by its [id]
  /// occurs in a list of Termtypes [l].

  bool _exsts(List<Termtype<A, B>> l, B id) {
    if (l.isEmpty) {
      // A variable cannot occur in an empty list of terms.
      return false;
    } else {
      Termtype<A, B> head = l.first; // head of List
      List<Termtype<A, B>> tail = l.sublist(1); // tail of list
      // apply the occurs check on each element of the list
      bool first = occurs(id,
          head); // indirect recursion to descend into the first term in the list.
      bool rest =
          _exsts(tail, id); // direct recursion over the rest of the list.
      return first || rest;
    }
  }

  //#######################################################
  //###
  //###   Substitution: _subst, _mp
  //###
  //#######################################################

  /// Performs substitution in [term]. The substitution is given
  /// by the [key], which is an id of a variable, and the [value] which is teh
  /// actual substitution.

  Termtype<A, B> _subst(
    B key, // entry in the list of substitutions, key part, id of the variable
    Termtype<A, B> value, // the actual substitution, value part,
    Termtype<A, B> term, // herein the substitution is performed
  ) {
    if (term is Var<A, B>) {
      if (key == term.id) {
        // return the substitution
        return value;
      } else {
        // return the orignial term
        return term;
      }
    } else if (term is Term<A, B>) {
      B id = term.id;
      List<Termtype<A, B>> listofterms = term.termlist;
      //
      List<Termtype<A, B>> right = _mp(key, value, listofterms);
      // return a new term with the same id
      return Term<A, B>(id, right);
    } else {
      throw Exception('_subst: Unknown Termtype or null ');
    }
  }

  /// A helper fuction for applying substitutions ([_subst]) on a list of terms [l]
  /// [key] is an the id of a variable in an entry in the list of substitutions,
  /// [value] the substitution.

  List<Termtype<A, B>> _mp(
    B key,
    Termtype<A, B> value,
    List<Termtype<A, B>> l,
  ) {
    if (l.isEmpty) {
      return (<Termtype<A, B>>[]);
    } else {
      Termtype<A, B> first = l.first; // head of list
      List<Termtype<A, B>> rest = l.sublist(1); // tails of list

      // applies a substitution
      // indirect recursion to descend into the first term in the list, applying the substitution
      Termtype<A, B> head = _subst(key, value, first);
      // direct recursion over the rest of the list.
      List<Termtype<A, B>> tail = _mp(key, value, rest);

      // concatenates results to list
      /*
      List<Termtype<A, B>> res = [head];
      res.addAll(tail);

      return res;*/

      return [head, ...tail];
    }
  }

  /// Looks up and applies a substitution from the list of substitutions [ths]
  /// with type List<Tupl<B, Termtype<A, B>>> given as first argument
  /// on a term [t] with type Termtype<A, B> given as last argument.
  /// might be replaced by a map
  Termtype<A, B> _apply(
    List<Tupl<B, Termtype<A, B>>> substitutions, // list of substitutions
    Termtype<A, B> term, // term to apply a substitution
  ) {
    if (substitutions.isEmpty) {
      // if the list of substitutions is empty the original term is returned
      return term;
    } else {
      // 1. Getting the first substitution
      // first element of the list of substitutions
      Tupl<B, Termtype<A, B>> first = substitutions.first;
      //
      // the key part of the mapping/binding, which is the id of a variable.
      B key = first.left;
      // the value part of the mapping/binding, which is the substitution.
      Termtype<A, B> value = first.right;

      // 2. Performing substitutions on the rest of the list of substitutions
      List<Tupl<B, Termtype<A, B>>> rest = substitutions.sublist(1);
      // direct recursion through the list of substitutions
      // to prepare the substitution before actually applying it
      Termtype<A, B> applied = _apply(rest, term);
      // indirect recursion performing  substitution
      Termtype<A, B> right = _subst(key, value, applied);
      return right;
    }
  }

  //#######################################################
  //###
  //###   Unification: unify, _unify_one
  //###
  //#######################################################

  /// Tries to unify two single Termtypes [s] and [t].
  /// Returns a list of substiturions of type List<Tupl<B, Termtype<A, B>>>.

  List<Tupl<B, Termtype<A, B>>> _unify_one(
    Termtype<A, B> s,
    Termtype<A, B> t,
    List<Tupl<B, Termtype<A, B>>> subs,
  ) {
    // Case 1: Try to unify two variables.
    if (s is Var<A, B> && t is Var<A, B>) {
      B ids = s.id;
      B idt = t.id;
      if (ids == idt) {
        // identical variables, do nothing, i.e. return bindings untouched
        return subs;
        // formerly: <Tupl<B, Termtype<A, B>>>[]
      } else {
        // add new binding
        return subs..add(Tupl<B, Termtype<A, B>>(ids, t));
      }

      // Case 2: Try to unify two Terms.
    } else if (s is Term<A, B> && t is Term<A, B>) {
      B ids = s.id;
      List<Termtype<A, B>> ls = s.termlist;

      B idt = t.id;
      List<Termtype<A, B>> lt = t.termlist;

      // Tries to unify two terms, i.e. their ids and their term lists of terms.
      if ((ids == idt) && (ls.length == lt.length)) {
        List<Tupl<Termtype<A, B>, Termtype<A, B>>> tuples =
            zip<Termtype<A, B>, Tupl<Termtype<A, B>, Termtype<A, B>>>(
                ls, lt, (left, right) => Tupl(left, right));

        return unify(tuples, subs);
      } else {
        throw Exception('_unify_one: Not unifiable, different ids or lengths.');
      }

      // Case 3: Try to unify a variable with a term.
    } else if (s is Var<A, B> && t is Term<A, B>) {
      B x = s.id;
      bool occursCheck = occurs(x, t); // true if occurs

      if (occursCheck) {
        throw Exception('_unify_one: Not unifiable, circularity/occurs==true.');
      } else {
        // new substitution is added to the list of substitutions.
        subs.add(Tupl(x, t));
        // switch back to "List<Tupl<B, Termtype<A, B>>> right =[Tupl(x, t)]"
        return subs; // switch back to "right"
      }

      // Case 4: Try to unify a term with a variable.
    } else if (s is Term<A, B> && t is Var<A, B>) {
      B x = t.id;
      bool occursCheck = occurs(x, s); // true if occurs

      if (occursCheck) {
        throw Exception('_unify_one: Not unifiable, circularity.');
      } else {
        // new substitution is added to the list of substitutions.
        subs.add(Tupl(x, s));
        // switch back to "List<Tupl<B, Termtype<A, B>>> right [Tupl(x, t)]"
        return subs; // switch back to "right"
      }
      // return _unify_one(t, s);
    } else {
      throw Exception('_unify_one: Unknown Termtype or null.');
    }
  }

  /// Unifies terms including the lists of terms that they hold.
  /// Returns a list of substitutions.

  List<Tupl<B, Termtype<A, B>>> unify(
    List<Tupl<Termtype<A, B>, Termtype<A, B>>> list, // a list of pairs of terms
    List<Tupl<B, Termtype<A, B>>> substitution, // the list of substitutions
  ) {
    if (list.isEmpty) {
      // no more pair of terms left to unify
      return (<Tupl<B, Termtype<A, B>>>[]);
    } else {
      // at least one pair of terms left to unify
      // head of list
      Termtype<A, B> firstLeft = list.first.left;
      Termtype<A, B> firstRight = list.first.right;

      // tail of list
      List<Tupl<Termtype<A, B>, Termtype<A, B>>> tail = list.sublist(1);
      // recursion on tail, i.e. list of terms, working through the termlist
      List<Tupl<B, Termtype<A, B>>> substitutionTail =
          unify(tail, substitution);

      // substitutionTail this will be applied on

      // apply substitutions before unification
      Termtype<A, B> firstLeftApplied = _apply(substitutionTail, firstLeft);
      Termtype<A, B> firstRightApplied = _apply(substitutionTail, firstRight);
      // unify one b one in reverse order,
      // returning when from recursion
      // rückgabe ist die liste der substitutionen.
      List<Tupl<B, Termtype<A, B>>> substitutionHead =
          _unify_one(firstLeftApplied, firstRightApplied, substitution);
      // die bei der Rückkehr aus der Rekursion aneinander gehängt werden
      return substitutionHead + substitutionTail;
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
