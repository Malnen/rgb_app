class CorsairK70Packets {
  final List<int> rPkt;
  final List<int> gPkt;
  final List<int> bPkt;

  CorsairK70Packets({
    required this.rPkt,
    required this.gPkt,
    required this.bPkt,
  });

  CorsairK70Packets.empty()
      : rPkt = <int>[],
        gPkt = <int>[],
        bPkt = <int>[];
}
