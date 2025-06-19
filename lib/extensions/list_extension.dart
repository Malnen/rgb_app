extension ListExtension<T> on List<T> {
  void replaceOrAdd(bool Function(T) test, T newValue) {
    final int index = indexWhere(test);
    if (index != -1) {
      this[index] = newValue;
    } else {
      add(newValue);
    }
  }
}
