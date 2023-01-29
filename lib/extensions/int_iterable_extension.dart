extension IntIterableExtension on Iterable<int> {
  int get max => reduce((int value, int element) => value > element ? value : element);

  int get min => reduce((int value, int element) => value < element ? value : element);
}
