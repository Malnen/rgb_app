class CorsairKeyboardPackets {
  final List<int> rPkt;
  final List<int> gPkt;
  final List<int> bPkt;

  CorsairKeyboardPackets({
    required this.rPkt,
    required this.gPkt,
    required this.bPkt,
  });

  CorsairKeyboardPackets.empty()
      : rPkt = <int>[],
        gPkt = <int>[],
        bPkt = <int>[];
}
