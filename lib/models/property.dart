abstract class Property<T> {
  T value;
  String name;
  void Function(T)? onChanged;

  Property({
    required this.value,
    required this.name,
    this.onChanged,
  });

  Map<String, Object> getData();

  void onChange(T value) {
    onChanged?.call(value);
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{
      'value': value,
      'name': name,
      'type': runtimeType.toString(),
    };
    final Map<String, Object?> data = getData();
    json.addAll(data);

    return json;
  }
}
