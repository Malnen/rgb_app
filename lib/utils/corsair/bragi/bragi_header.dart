abstract class BragiHeader {
  const BragiHeader();

  int get requestLength;

  int get commandOffset;

  bool get usesSessions;

  int get statusOffset => commandOffset + 1;

  int get payloadOffset => statusOffset + 1;

  List<int> encode(int command, {required int session, required bool reply});

  bool matchesRouting(List<int> response, int session);

  int protocolStatus(List<int> response);

  bool matchesResponse(List<int> response, {required int command, required int session}) {
    final bool validHeader = response.length > statusOffset && response[0] == 0 && response[commandOffset] == command;
    return validHeader && matchesRouting(response, session);
  }
}
