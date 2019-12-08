// part of unification;

/// [ZipFun2] is the type of a function applicable on each elements of two lists
/// in [zip2]
///
///
typedef S ZipFun2<T, S>(T a, T b);

/// [zip2] applies a function on each elements of two lists
List<S> zip<T, S>(List<T> l1, List<T> l2, ZipFun2<T, S> f) {
  if (l1 == null || l2 == null) {
    throw Exception( 'Error in zip: List ist null ');
  }

  List<S> res = <S>[];
  int len1 = l1.length;
  int len2 = l2.length;
  if (len1 != len2) {
    throw Exception( 'Error in zip: Listen ungleich lang ');
  }
  for (int i = 0; i < len1; i++) {
    res.add(f(l1[i], l2[i]));
  }
  return res;
}

/// [range] generates an [Iterable] of integers within a given range
/// between [low] and [high]

Iterable<int> range(int low, int high) sync* {
  for (int i = low; i < high; ++i) {
    yield i;
  }
}

/// [rangeList] generates an [List] of integers within a given range
/// between [low] and [high]

List<int> rangeList(int low, int high) => range(low, high).toList();
