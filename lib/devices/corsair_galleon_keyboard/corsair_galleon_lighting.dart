import 'package:rgb_app/utils/corsair/bragi/corsair_bragi_protocol.dart';

class CorsairGalleonLighting {
  static const int ledCount = 146;

  final CorsairBragiProtocol _protocol;
  bool _ready = false;
  bool _lightingOpened = false;
  List<int>? _originalMode;
  List<int>? _originalBrightness;

  CorsairGalleonLighting({required CorsairBragiProtocol protocol}) : _protocol = protocol;

  List<List<int>> get initializationPackets {
    final List<int> mode = _protocol.createPacket(1, <int>[3, 0, 2, 0, 0, 0]);
    final List<int> brightness = _protocol.createPacket(1, <int>[2, 0, 0xe8, 3, 0, 0]);
    final List<int> lighting = _protocol.createPacket(0x0d, <int>[0, 0x22, 0]);

    return <List<int>>[mode, brightness, lighting];
  }

  Future<void> initialize() async {
    await close();
    try {
      await _protocol.initialize();
      _originalMode = await _protocol.readProperty(3);
      _originalBrightness = await _protocol.readProperty(2);
      final List<List<int>> packets = initializationPackets;
      for (final List<int> packet in packets) {
        await _protocol.execute(packet);
      }

      _lightingOpened = true;
      final List<int> mode = await _protocol.readProperty(3);
      if (mode[0] == 2) {
        _ready = true;
      } else {
        throw StateError('Galleon did not enter software lighting mode: $mode');
      }
    } catch (error, stackTrace) {
      try {
        await close();
      } catch (cleanupError) {
        final StateError failure = StateError('Galleon initialization failed: $error; cleanup also failed: $cleanupError');
        Error.throwWithStackTrace(failure, stackTrace);
      }

      rethrow;
    }
  }

  Future<void> close() async {
    _ready = false;
    final List<List<int>> packets = _releasePackets();
    final List<String> failures = <String>[];
    for (final List<int> packet in packets) {
      try {
        await _protocol.execute(packet);
      } catch (error) {
        final String failure = error.toString();
        failures.add(failure);
      }
    }

    try {
      await _protocol.close();
    } catch (error) {
      final String failure = error.toString();
      failures.add(failure);
    }

    _lightingOpened = false;
    _originalMode = null;
    _originalBrightness = null;
    if (failures.isNotEmpty) {
      final String details = failures.join('; ');
      throw StateError('Galleon cleanup failed: $details');
    }
  }

  List<List<int>> lightingPackets(List<int> colors) {
    if (_ready && colors.length == ledCount * 3) {
      final List<int> payload = <int>[0x12, 0, ...colors];
      return _protocol.writePackets(buffer: 0, payload: payload);
    }

    throw StateError('Galleon lighting is not initialized or RGB length is not 438');
  }

  Future<List<int>> execute(List<int> packet) => _protocol.execute(packet);

  List<List<int>> _releasePackets() {
    final List<List<int>> packets = <List<int>>[];
    if (_lightingOpened) {
      final List<int> unbind = _protocol.createPacket(5, <int>[1, 0]);
      packets.add(unbind);
    }

    final List<int>? brightness = _originalBrightness;
    if (brightness != null) {
      final List<int> restoreBrightness = _protocol.createPacket(1, <int>[2, 0, ...brightness]);
      packets.add(restoreBrightness);
    }

    final List<int>? mode = _originalMode;
    if (mode != null) {
      final List<int> restoreMode = _protocol.createPacket(1, <int>[3, 0, ...mode]);
      packets.add(restoreMode);
    }

    return packets;
  }
}
