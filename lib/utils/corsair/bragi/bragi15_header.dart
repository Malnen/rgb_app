import 'package:rgb_app/utils/corsair/bragi/bragi_header.dart';

class Bragi15Header extends BragiHeader {
  const Bragi15Header();

  @override
  int get requestLength => 5;

  @override
  int get commandOffset => 4;

  @override
  bool get usesSessions => true;

  @override
  List<int> encode(int command, {required int session, required bool reply}) => <int>[0, 0, reply ? 1 : 0, session, command];

  @override
  bool matchesRouting(List<int> response, int session) => response[1] == 0 && response[3] == session;

  @override
  int protocolStatus(List<int> response) => response[2];
}
