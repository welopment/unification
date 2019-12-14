import 'package:unification/unification.dart';

class Visited {
  Visited(this.i, this.t);

  int i;
  Type t;
}

/// Unification nach Privara Rusizca
class UnificationPR<A, Id> {
  //#################################################################
  //###
  //###   Unification: unify,
  //###
  //###
  //###        unify:
  //###
  //###
  //###
  //###
  //##############################################################
  var visited = <Visited>{};
  bool unify(
    Termtype<A, Id> s,
    Termtype<A, Id> t,
  ) {
    var b = true;
    // Case 1: Try to unify two variables.
    if (s is Var<A, Id> && t is Var<A, Id>) {
      // nichts tun, da Variablen nicht eliminiert werden können.

      // Case 2: Try to unify two Terms.
      // Tries to unify two terms, i.e. their ids and their term lists of terms.
    } else if (s is Term<A, Id> && t is Term<A, Id>) {
      if (s.id != t.id /*TODO: nur names vergleichen*/) {
        b = false;
        return false;
      }

      Id ids = s.id;
      List<Termtype<A, Id>> l1 = s.termlist;

      Id idt = t.id;
      List<Termtype<A, Id>> l2 = t.termlist;

      int len1 = l1.length;
      int len2 = l2.length;

      if (len1 != len2) {
        throw Exception('unify: list of different lengths.');
      }

      for (int i = 0; i < len1; i++) {
        Termtype<A, Id> w1 = l1[i];
        Termtype<A, Id> w2 = l2[i];

        // hier beginnt hierarchisch hochgezogenes replace
        // Case 3: Try to unify a variable with a term.
        if (w1 is Var<A, Id> && w2 is Term<A, Id>) {
          //TODO:  replace:   w1 durch w2 ersetzen
          l1[i] = l2[i];
          b = true;
          continue;
          // Case 4: Try to unify a term with a variable.
        } else if (w1 is Term<A, Id> && w2 is Var<A, Id>) {
          //TODO: replace:   w2 durch w1 ersetzen
          l2[i] = l1[i];
          b = true;
          continue;
        }
        // Muß Änderung auch mitbekommen.
        w1 = l1[i];
        w2 = l2[i];
        // hier endet hierarchisch hochgezogenes replace
      
        if (visited.contains(w1) || visited.contains(w2)) {
          b = false;
          return false;
        } else if (w1.id != w2.id /*TODO nur names vergleichen*/) {
          visited.add(Visited(w1.hashCode, w1.runtimeType));
          visited.add(Visited(w2.hashCode, w2.runtimeType));

          b = unify(w1, w2);

          visited.remove(Visited(w1.hashCode, w1.runtimeType));
          visited.remove(Visited(w2.hashCode, w2.runtimeType));
        }
      }

      // Case 3: Try to unify a variable with a term.
    }
    /*else if (s is Var<A, Id> && t is Term<A, Id>) {
      //TODO: replace
      return true;

      // Case 4: Try to unify a term with a variable.
    } else if (s is Term<A, Id> && t is Var<A, Id>) {
      //TODO: replace

      return true;
    }
    */
    return b;
  }
}
