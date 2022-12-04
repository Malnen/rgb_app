import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class EffectData extends Equatable {
  final String name;
  final String className;
  final IconData iconData;
  final Key key;

  EffectData({
    required this.name,
    required this.className,
    required this.iconData,
    final Key? key,
  }) : key = key ?? UniqueKey();

  EffectData getWithNewKey() {
    return copyWith(key: UniqueKey());
  }

  EffectData copyWith({
    final String? name,
    final String? className,
    final IconData? iconData,
    final Key? key,
  }) {
    return EffectData(
      name: name ?? this.name,
      className: className ?? this.className,
      iconData: iconData ?? this.iconData,
      key: key ?? this.key,
    );
  }

  @override
  List<Object> get props => <Object>[
        name,
        className,
        iconData,
        key,
      ];
}
