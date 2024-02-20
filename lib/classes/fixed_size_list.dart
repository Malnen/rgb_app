import 'dart:collection';

class FixedSizeList<T> extends ListBase<T> {
  final int maxSize;

  final List<T> _list = <T>[];

  FixedSizeList({this.maxSize = 100});

  @override
  int get length => _list.length;

  @override
  set length(int value) => _list.length = value;

  @override
  T operator [](int index) => _list[index];

  @override
  void operator []=(int index, T value) => _list[index] = value;

  @override
  void add(T element) {
    if (length > maxSize) {
      _list.removeAt(0);
    }

    _list.add(element);
  }
}
