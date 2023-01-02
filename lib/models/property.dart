abstract class Property<T> {
  T value;
  String name;

  Property({required this.value, required this.name});

  Map<String, Object> getData();

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
