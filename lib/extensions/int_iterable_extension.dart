extension IntIterableExtension on Iterable<int> {
  int get max => reduce((final int value, final int element) => value > element ? value : element);

  int get min => reduce((final int value, final int element) => value < element ? value : element);
}
