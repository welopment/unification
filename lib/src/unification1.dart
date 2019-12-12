import 'utils.dart';
import 'terms.dart';
export 'terms.dart';

// - rename Tupl
// - origin of terms
// - replace Exceptions

/// not trampolined version
/// without helper functions

class UnificationR<A, B> {
  //#######################################################
  //###
  //###   Occurs Check:   occurs <->  _exsts <<
  //###
  //###
  //###
  //#######################################################

  /// Performs an occurs check and returns the result as bool.

  bool occurs(B id, Termtype<A, B> t) {
    if (t is Var<A, B>) {
      B tid = t.id;
      // case 1: test for identity of variables
      return (id == tid);
    } else if (t is Term<A, B>) {
      List<Termtype<A, B>> s = t.termlist;
      // case 2: search through lists of terms
      return _exists(s, id);
    } else {
      throw Exception('occurs: Unknown Termtype or null.');
    }
  }

  /// A helper fuction for occurs checking lists of terms.
  /// Checks if the target variable represented by its [id]
  /// occurs in a list of terms [l].

  bool _exists(List<Termtype<A, B>> l, B id) {
    if (l.isEmpty) {
      // A variable cannot occur in an empty list of terms.
      return false;
    } else {
      Termtype<A, B> head = l.first; // head of List
      List<Termtype<A, B>> tail = l.sublist(1); // tail of list
      // apply the occurs check on each element of the list
      // indirect recursion to descend into the first term in the list.
      bool first = occurs(id, head);
      // direct recursion over the rest of the list.
      bool rest = _exists(tail, id);

      return first || rest;
    }
  }

  //#######################################################
  //###
  //###   Substitution: >> _lookup  ->  _substitute  <->  _substituteList <<
  //###
  //###
  //###
  //###
  //#######################################################

  /// Look up a binding/substitution from the list of [substitutions].
 
  Termtype<A, B> _lookup(
    List<Tupl<B, Termtype<A, B>>> substitutions, // list of substitutions
    Termtype<A, B> term, // term to apply a substitution to
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
      // the value part of the binding/substitution.
      Termtype<A, B> value = first.right;

      // 2. Looking for substitutions in the rest of the list of substitutions
      List<Tupl<B, Termtype<A, B>>> rest = substitutions.sublist(1);

      /// direct recursion through the list of substitutions 
      Termtype<A, B> applied = _lookup(rest, term);

      /// indirect recursion 
      /// =  actually performing substitution, ascending from recursion
      Termtype<A, B> right = _substitute(key, value, applied);
      return right;
    }
  }

  /// Actually performs a substitution on a [term]. A binding/substitution
  /// is given by a [key], which is the id of a variable listed in binding,
  /// and a [value], which is the actual substitution to be apply on [term].

  Termtype<A, B> _substitute(
    B key, // entry in the list of substitutions, key part, id of the variable
    Termtype<A, B> value, // the actual substitution, value part,
    Termtype<A, B> term, // term that the substitution is to be performed on
  ) {
    if (term is Var<A, B>) {
      if (key == term.id) {
        /// Actually performs the substitution !
        return value;
      } else {
        /// return the orignial term, if binding not found
        /// in bindings
        return term;
      }
    } else if (term is Term<A, B>) {
      B id = term.id;
      List<Termtype<A, B>> listoftermsbefore = term.termlist;
      List<Termtype<A, B>> listoftermsafter =
          _substituteList(key, value, listoftermsbefore);

      /// Actually returns the substitution performed above !
      /// Copies ... improvement possible?
      return Term<A, B>(id, listoftermsafter);
    } else {
      throw Exception('_subst: Unknown Termtype or null ');
    }
  }

  /// A helper fuction for applying bindings/substitutions on a list of [terms].
  /// [key] is the id of a variable listed in a binding/substitution,
  /// and [value] is term listed in the binding/substitution.

  List<Termtype<A, B>> _substituteList(
    B key,
    Termtype<A, B> value,
    List<Termtype<A, B>> terms,
  ) {
    if (terms.isEmpty) {
      return (<Termtype<A, B>>[]);
    } else {
      Termtype<A, B> first = terms.first; // head of list
      List<Termtype<A, B>> rest = terms.sublist(1); // tails of list

      // applies a substitution
      // indirect recursion to descend into the first term in the list, applying the substitution
      Termtype<A, B> head = _substitute(key, value, first);
      // direct recursion over the rest of the list.
      List<Termtype<A, B>> tail = _substituteList(key, value, rest);

      // concatenate results to list

      /*
      List<Termtype<A, B>> res = [head];
      res.addAll(tail);
      return res;
      */

      return [head, ...tail];
    }
  }

  //#################################################################
  //###
  //###   Unification: unify, _unify_one
  //###
  //###
  //###        unify:  applies substitutions/bindings ascending
  //###                  from recursion over termlists
  //###   _unify_one:  compares and adds substitutions/bindings
  //###
  //###
  //##############################################################

  /// Tries to unify two single Termtypes [s] and [t].
  /// Compares and adds bindings. Doesnt apply substitutions,
  /// no occurance of _apply or _subst.
  /// Returns a list of substiturions of type List<Tupl<B, Termtype<A, B>>>.

  List<Tupl<B, Termtype<A, B>>> _unify_one(
    Termtype<A, B> s,
    Termtype<A, B> t,
    List<Tupl<B, Termtype<A, B>>> substitutionInitial,
  ) {
    // Case 1: Try to unify two variables.
    if (s is Var<A, B> && t is Var<A, B>) {
      B ids = s.id;
      B idt = t.id;
      if (ids == idt) {
        // identical variables, do nothing, i.e. return bindings untouched
        return substitutionInitial;
        // formerly: <Tupl<B, Termtype<A, B>>>[]
      } else {
        // add new binding
        return substitutionInitial..add(Tupl<B, Termtype<A, B>>(ids, t));
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

        return unify(tuples, substitutionInitial);
      } else {
        throw Exception('_unify_one: Not unifiable, different ids or lengths.');
      }

      // Case 3: Try to unify a variable with a term.
    } else if (s is Var<A, B> && t is Term<A, B>) {
      B sid = s.id;
      bool occursCheck = occurs(sid, t); // true if occurs

      if (occursCheck) {
        throw Exception('_unify_one: Not unifiable, circularity/occurs==true.');
      } else {
        // new substitution is added to the list of substitutions.
        substitutionInitial.add(Tupl(sid, t));
        // switch back to "List<Tupl<B, Termtype<A, B>>> right =[Tupl(x, t)]"
        return substitutionInitial; // switch back to "right"
      }

      // Case 4: Try to unify a term with a variable.
    } else if (s is Term<A, B> && t is Var<A, B>) {
      B tid = t.id;
      bool occursCheck = occurs(tid, s); // true if occurs

      if (occursCheck) {
        throw Exception('_unify_one: Not unifiable, circularity/occurs==true.');
      } else {
        // new substitution is added to the list of substitutions.
        substitutionInitial.add(Tupl(tid, s));
        // switch back to "List<Tupl<B, Termtype<A, B>>> right [Tupl(x, t)]"
        return substitutionInitial; // switch back to "right"
      }
      // return _unify_one(t, s);
    } else {
      throw Exception('_unify_one: Unknown Termtype or null.');
    }
  }

  /// Tries to unify terms including lists of terms that they hold.
  /// Calls _apply, i.e. applies substitutions
  /// Doesnt add bindings.
  /// Returns a list of substitutions.

  List<Tupl<B, Termtype<A, B>>> unify(
    List<Tupl<Termtype<A, B>, Termtype<A, B>>> list, // a list of pairs of terms
    List<Tupl<B, Termtype<A, B>>>
        substitutionInitial, // the initial list of substitutions; improve!
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
      // substitutionInitial
      List<Tupl<B, Termtype<A, B>>> substitutionTail = unify(
        tail,
        substitutionInitial,
      );

      // substitution precedes in reverse order, ascending from unify
      // substitutionTail this will be applied on head terms, before unified

      // apply substitutions before unification, in reverse order, ascending from unify.
      Termtype<A, B> firstLeftApplied = _lookup(substitutionTail, firstLeft);
      Termtype<A, B> firstRightApplied = _lookup(substitutionTail, firstRight);
      // unify one by one in reverse order, ascending from recursion performed by unify

      List<Tupl<B, Termtype<A, B>>> substitutionHead = _unify_one(
        firstLeftApplied,
        firstRightApplied,
        substitutionInitial, // richtig?
      );
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
  bool unifiable = false;
}
