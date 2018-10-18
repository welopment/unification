/*import 'utils.dart';
//import 'terms.dart';
//export 'terms.dart';

/// not trampolined version



/// occurs check

bool occurs(String x, Termtype t) {
  if (t is Var) {
    var y = t.id;
    return (x == y);
  } else if (t is Term) {
    var s = t.termlist;
    return _exsts(s, x);
  } else if (x == null || t == null) {
    throw new Exception("occurs: Variable name  or Termtype is null");
  } else {
    throw new Exception("occurs: Unknown Exception");
  }
}

/// helper fuction for occurs check

bool _exsts(List<Termtype> l, String target) {
  if (l.isEmpty) {
    return (false);
  } else {
    Termtype lh = l.first;
    List<Termtype> lt = l.sublist(1);

    var right = _exsts(lt, target);
    var left = occurs(target, lh);
    return (left || right);
  }
}

/// substitution

Termtype _subst(Termtype s, String x, Termtype t) {
  if (t is Var) {
    if (x == t.id) {
      return (s);
    } else {
      return (t);
    }
  } else if (t is Term) {
    String f = t.id;
    List<Termtype> u = t.termlist;
    var right = _mp(s, x, u);
    return new Term(f, right);

 
  } else {
    throw new Exception("Subst: Unbehandelter Fall");
  }
}

/// 

List<Termtype> _mp(Termtype s, String x, List<Termtype> l) {
  assert(l != null);
  if (l.isEmpty) {
    return (new List<Termtype>());
  } else {
    var lh = l.first;
    var lt = l.sublist(1);
    assert(lh != null);
    assert(lt != null);
    // for
    var right = _mp(s, x, lt);

    var left = _subst(s, x, lh);

    var res = [left];
    res.addAll(right);
    return res;


  }
}

/// apply substitution

Termtype _apply(List<Tupl<String, Termtype>> ths, Termtype z) {
  if (ths.isEmpty) {
    return (z);
  } else {
    Tupl<String, Termtype> frst = ths.first;
    String x = frst.left;
    Termtype u = frst.right;

    var xs = ths.sublist(1);

    var apd = _apply(xs, z);

    if (apd is Term) {
      assert(apd.id != null);
    }
    var right = _subst(u, x, apd);
    return right;


  }
}

///  unify two ingle Termtypes, one by one

List<Tupl<String, Termtype>> _unify_one(Termtype s, Termtype t) {
  if (s == null || t == null) {
    throw new Exception("occurs: Termtype is null");
  } else if (s is Var && t is Var) {
    var x = s.id;
    var y = t.id;

    if (x == y) {
      return new List<Tupl<String, Termtype>>();
    } else {
      return new List<Tupl<String, Termtype>>()
        ..add(new Tupl<String, Termtype>(x, t));
    }
  } else if (s is Term && t is Term) {
    var f = s.id;
    var sc = s.termlist;

    var g = t.id;
    var tc = t.termlist;

    if ((f == g) && (sc.length == tc.length)) {
      List<Tupl<Termtype, Termtype>> zpd =
          zip<Termtype, Tupl<Termtype, Termtype>>(
              sc, tc, (left, right) => new Tupl(left, right));

      return unify(zpd);
    } else {
      throw new Exception("Not unifiable #1");
    }
  } else if (s is Var && t is Term) {
    return _unifyhelper(t, s.id);



  } else if (s is Term && t is Var) {
    return _unifyhelper(s, t.id);

  } else {
    throw new Exception("Not unifiable #2");
  }
}

///helper function for unify_one

List<Tupl<String, Termtype>> _unifyhelper(Termtype t, String x) {
  var left = occurs(x, t);
  var right = ([new Tupl(x, t)]);
  List<Tupl<String, Termtype>> innerres;

  if (left) {
    throw new Exception("not unifiable: circularity");
  } else {
    innerres = right;
  }

  return innerres;
}

/// unify a list of terms

List<Tupl<String, Termtype>> unify(List<Tupl<Termtype, Termtype>> s) {
  if (s.isEmpty) {
    return (new List<Tupl<String, Termtype>>());
  } else {
    Termtype x = s.first.left;
    Termtype y = s.first.right;
    List<Tupl<Termtype, Termtype>> t = s.sublist(1);
    var t2 = unify(t);
    var left = _apply(t2, x);
    var right = _apply(t2, y);
    var t1 = _unify_one(left, right);

    t1.addAll(t2);
    return t1;
  }
}
*/
