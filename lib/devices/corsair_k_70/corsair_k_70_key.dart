import 'package:equatable/equatable.dart';
import 'package:rgb_app/enums/key_code.dart';

class CorsairK70Key extends Equatable {
  final int packetIndex;
  final int index;
  final KeyCode keyCode;

  const CorsairK70Key({
    required this.packetIndex,
    required this.index,
    required this.keyCode,
  });

  @override
  List<Object> get props => <Object>[
        packetIndex,
        index,
        keyCode,
      ];
}
