import 'package:rgb_app/utils/corsair/bragi/bragi_header.dart';

class LegacyBragiHeader extends BragiHeader {
  const LegacyBragiHeader();

  @override
  int get requestLength => 3;

  @override
  int get commandOffset => 2;

  @override
  bool get usesSessions => false;

  @override
  List<int> encode(int command, {required int session, required bool reply}) => <int>[0, reply ? 8 : 0, command];

  @override
  bool matchesRouting(List<int> response, int session) => response[1] & 7 == 0;

  @override
  int protocolStatus(List<int> response) => response[1] >> 4;
}
