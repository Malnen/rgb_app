import 'package:equatable/equatable.dart';

class EffectGridData extends Equatable {
  final int sizeX;
  final int sizeY;

  EffectGridData({
    required this.sizeX,
    required this.sizeY,
  });

  @override
  List<Object> get props => <Object>[];

  EffectGridData.fromJson(Map<String, dynamic> json)
      : sizeX = json['sizeX'] as int,
        sizeY = json['sizeY'] as int;

  Map<String, dynamic>? toJson() {
    return {'sizeX': sizeX, 'sizeY': sizeY};
  }

  EffectGridData copyWith({
    int? sizeX,
    int? sizeY,
  }) {
    return EffectGridData(
      sizeX: sizeX ?? this.sizeX,
      sizeY: sizeY ?? this.sizeY,
    );
  }
}
