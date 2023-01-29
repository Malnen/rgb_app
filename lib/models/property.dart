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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'value': value,
      'name': name,
      'type': runtimeType.toString(),
    };
    final Map<String, dynamic> data = getData();
    json.addAll(data);

    return json;
  }
}
