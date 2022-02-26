import 'package:equatable/equatable.dart';

class CorsairK70Key extends Equatable {
  final int packetIndex;
  final int index;
  final String keyName;

  CorsairK70Key({
    required this.packetIndex,
    required this.index,
    required this.keyName,
  });

  @override
  List<Object> get props => <Object>[
        packetIndex,
        index,
        keyName,
      ];
}
