import 'dart:typed_data';

class CorsairK70Packets {
  final Uint8List rPkt;
  final Uint8List gPkt;
  final Uint8List bPkt;

  CorsairK70Packets({
    required this.rPkt,
    required this.gPkt,
    required this.bPkt,
  });

  CorsairK70Packets.empty()
      : rPkt = Uint8List.fromList(<int>[]),
        gPkt = Uint8List.fromList(<int>[]),
        bPkt = Uint8List.fromList(<int>[]);
}
