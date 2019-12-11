import 'dart:collection' ;

// utilities from https://github.com/mythz/dart-linq-examples

int wrap<T>(T value, int Function (T) fn) {
  return fn(value);
}

List order<T>(List<T> seq, Comparator by, List<Comparator<T>> byAll, int Function(T) on,
    List<int Function(T)> onAll) {
  by != null
      ? (seq..sort(by))
      : byAll != null
          ? (seq
            ..sort((T a, T b) => byAll.firstWhere((compare) => compare(a, b) != 0,
                orElse: () => (T x,T y) => 0)(a, b)))
          : on != null
              ? (seq..sort((T a,T b) => on(a).compareTo(on(b))))
              : onAll != null
                  ? (seq
                    ..sort((T a,T b) => wrap(
                        onAll.firstWhere((_on) => _on(a).compareTo(_on(b)) != 0,
                            orElse: () => (T x) => 0),
                        (int Function(T) _on) => _on(a).compareTo(_on(b)))))
                  : (seq..sort());
  return seq;
}

int caseInsensitiveComparer(String a, String b) =>
    a.toUpperCase().compareTo(b.toUpperCase());


///////////////////////////////////////
// 2.
/*
anagramEqualityComparer(a, b) => 
  new String.fromCharCodes(orderBy(a.codeUnits.toList()))
  .compareTo(new String.fromCharCodes(orderBy(b.codeUnits.toList())));

List<Group> group(Iterable seq, {by(x):null, Comparator matchWith:null, valuesAs(x):null}){
  var ret = [];
  var map = new Map<dynamic, Group>();
  seq.forEach((x){
    var val = by(x);
    var key = matchWith != null
      ? map.keys.firstWhere((k) => matchWith(val, k) == 0, orElse:() => val)
      : val;
    
    if (!map.containsKey(key))
      map[key] = new Group(val);
    
    if (valuesAs != null)
      x = valuesAs(x);
    
    map[key].add(x);
  });
  return map.values.toList();
}

class Group extends IterableBase {
  var key;
  List _list;
  Group(this.key) : _list = [];

  get iterator => _list.iterator;
  void add(e) => _list.add(e);  
  get values => _list;
}
 */
/*
int anagramEqualityComparer<T>(T a, T b) => 
   String.fromCharCodes(orderBy(a.codeUnits.toList()))
  .compareTo( String.fromCharCodes(orderBy(b.codeUnits.toList())));

List<Group<int>> group<T>(Iterable<T> seq, int Function(T) by, Comparator matchWith, T Function(T) valuesAs){
  List<T> ret = <T>[];
  Map<int, Group<int>> map =  <int, Group<int>>{};
  seq.forEach((T x){
    int val = by(x);
    int key = (matchWith != null)
      ? map.keys.firstWhere((int k) => matchWith(val, k) == 0, orElse:() => val)
      : val;
    
    if (!map.containsKey(key)) {
      map[key] =  Group<int>(val);
    }
    
    if (valuesAs != null) {
      x = valuesAs(x);
    }
    
    map[key].add(x);
  });
  return map.values.toList();
}

class Group<T> extends IterableBase<T> {
  Group(this.key) : _list = <T>[];

  T key;
  final List<T> _list;

  Iterator<T> get iterator => _list.iterator;
  void add(T e) => _list.add(e);  
 List<T> get values => _list;
}
*/