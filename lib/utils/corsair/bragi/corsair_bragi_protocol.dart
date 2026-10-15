import 'dart:async';
import 'dart:math';

import 'package:rgb_app/utils/corsair/bragi/bragi15_header.dart';
import 'package:rgb_app/utils/corsair/bragi/bragi_header.dart';
import 'package:rgb_app/utils/corsair/bragi/legacy_bragi_header.dart';

class CorsairBragiProtocol {
  final int reportLength;

  final Future<void> Function(List<int> packet) _write;
  final Future<List<int>> Function(int timeout) _read;
  final Random _random;

  late BragiHeader _header;
  late int _session;

  CorsairBragiProtocol({
    required this.reportLength,
    required Future<void> Function(List<int> packet) write,
    required Future<List<int>> Function(int timeout) read,
    Random? random,
  })  : _write = write,
        _read = read,
        _random = random ?? Random.secure() {
    _header = const LegacyBragiHeader();
    _session = 0;
  }

  bool get usesSessions => _header.usesSessions;

  Future<void> initialize() async {
    await close();
    await _negotiate();
    if (usesSessions) {
      await _startSession();
    }
  }

  Future<void> close() async {
    if (usesSessions && _session != 0) {
      final List<int> packet = createPacket(0x1b, <int>[2, 0, 0, 0, 0, _session]);
      try {
        await execute(packet);
      } finally {
        _session = 0;
      }
    }
  }

  Future<List<int>> readProperty(int property) async {
    final List<int> propertyId = _littleEndian(property, 2);
    final List<int> request = createPacket(2, propertyId);
    final List<int> response = await execute(request);
    if (response.length >= 4) {
      return response.sublist(0, 4);
    }

    throw StateError('Bragi property $property response is shorter than four bytes: $response');
  }

  List<List<int>> writePackets({required int buffer, required List<int> payload}) {
    final int initialSize = min(reportLength - _header.requestLength - 5, payload.length);
    final int continuationSize = reportLength - _header.requestLength - 1;
    final List<int> size = _littleEndian(payload.length, 4);
    final List<int> initial = payload.sublist(0, initialSize);
    final List<int> first = createPacket(6, <int>[buffer, ...size, ...initial], reply: false);
    final List<List<int>> packets = <List<int>>[first];
    int cursor = initialSize;
    while (cursor < payload.length) {
      final int end = min(cursor + continuationSize, payload.length);
      final List<int> chunk = payload.sublist(cursor, end);
      final List<int> packet = createPacket(7, <int>[buffer, ...chunk], reply: false);
      packets.add(packet);
      cursor = end;
    }

    return packets;
  }

  Future<List<int>> execute(List<int> packet) async {
    final int command = packet[_header.commandOffset];
    await _write(packet);
    for (int attempt = 0; attempt < 4; attempt++) {
      final List<int> response = await _read(1000);
      final bool matches = _header.matchesResponse(response, command: command, session: _session);
      if (matches) {
        return _responsePayload(response, command);
      }

      if (response.isEmpty) {
        throw TimeoutException('Bragi returned no ACK for command $command, session $_session');
      }
    }

    throw StateError('Bragi returned no matching ACK for command $command, session $_session');
  }

  List<int> createPacket(int command, List<int> data, {bool reply = true}) {
    final List<int> header = _header.encode(command, session: _session, reply: reply);
    final int size = header.length + data.length;
    if (size <= reportLength) {
      final List<int> packet = List<int>.filled(reportLength, 0);
      packet.setRange(0, header.length, header);
      packet.setRange(header.length, size, data);

      return packet;
    }

    throw ArgumentError('Bragi packet size $size exceeds HID report length $reportLength');
  }

  Future<void> _negotiate() async {
    if (reportLength >= 16 && reportLength <= 65536) {
      _header = const Bragi15Header();
      final List<int> probe = createPacket(2, <int>[5, 1]);
      await _write(probe);
      List<int> response;
      try {
        response = await _read(250);
      } on TimeoutException {
        response = <int>[];
      }

      final bool matches = _header.matchesResponse(response, command: 2, session: 0);
      if (matches && response.length >= _header.payloadOffset + 2) {
        final int protocolStatus = _header.protocolStatus(response);
        final int status = response[_header.statusOffset];
        if (protocolStatus == 0 && status == 0) {
          final int major = response[_header.payloadOffset];
          final int minor = response[_header.payloadOffset + 1];
          if (major == 1 && minor == 5) {
            return;
          }

          throw StateError('Unsupported Bragi version $major.$minor');
        }
      }

      await _negotiateLegacy();
    } else {
      throw ArgumentError.value(reportLength, 'reportLength', 'Unsupported HID output report size');
    }
  }

  Future<void> _negotiateLegacy() async {
    _header = const LegacyBragiHeader();
    final List<int> vendorPacket = createPacket(2, <int>[0x11, 0]);
    final List<int> vendor = await execute(vendorPacket);
    if (vendor.length >= 2 && vendor[0] == 0x1c && vendor[1] == 0x1b) {
      return;
    }

    throw StateError('Bragi protocol detection failed: invalid vendor response $vendor');
  }

  Future<void> _startSession() async {
    final List<int> nonce = List<int>.generate(4, (int index) => _random.nextInt(256));
    final List<int> packet = createPacket(0x1b, <int>[1, ...nonce, 0]);
    final List<int> response = await execute(packet);
    bool nonceMatches = response.length >= 5;
    if (nonceMatches) {
      for (int index = 0; index < 4; index++) {
        nonceMatches = nonceMatches && response[index] == nonce[index];
      }
    }

    if (nonceMatches && response[4] > 0 && response[4] < 16) {
      _session = response[4];
    } else {
      throw StateError('Bragi returned an invalid session response: $response');
    }
  }

  List<int> _responsePayload(List<int> response, int command) {
    final int protocolStatus = _header.protocolStatus(response);
    final int status = response[_header.statusOffset];
    if (protocolStatus == 0 && status == 0) {
      return response.sublist(_header.payloadOffset);
    }

    final String commandHex = command.toRadixString(16);
    throw StateError('Bragi command 0x$commandHex rejected: protocol=$protocolStatus, status=$status, session=$_session');
  }

  List<int> _littleEndian(int value, int length) => List<int>.generate(length, (int index) => (value >> (index * 8)) & 0xff);
}
