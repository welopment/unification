import 'package:unification/unification.dart';

/// The type of a function that is applied on the elements of two lists by zip
typedef ZipFun2<T, S> = S Function(T a, T b);

/// Applies a function on each pair elements of two lists of equal lenght
List<S> zip<T, S>(List<T> l1, List<T> l2, ZipFun2<T, S> f) {
  if (l1 == null || l2 == null) {
    throw Exception('zip: one of the lists ist null. ');
  }

  int len1 = l1.length;
  int len2 = l2.length;

  if (len1 != len2) {
    throw Exception('zip: list of different lengths.');
  }

  List<S> res = <S>[];

  for (int i = 0; i < len1; i++) {
    res.add(f(l1[i], l2[i]));
  }
  return res;
}

/// Generates enerates an [Iterable] of integers spanning a range
/// from [low] (inclusive) to [high] (exclusive).

Iterable<int> range(int low, int high) sync* {
  for (int i = low; i < high; ++i) {
    yield i;
  }
}

/// Generates a [List] of integers spanning a range
/// from [low] (inclusive) to [high] (exclusive).

List<int> rangeList(int low, int high) => range(low, high).toList();
