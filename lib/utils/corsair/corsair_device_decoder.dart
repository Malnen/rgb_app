import 'dart:convert';

import 'package:rgb_app/models/sub_component.dart';
import 'package:vector_math/vector_math.dart';

class CorsairDeviceNameMap {
  static const Map<int, String> _baseNames = <int, String>{
    1: 'QX Fan',
    255: 'QX Fan',
    6: 'LINK LCD',
  };

  static String getDeviceName(int deviceType, int coolerType) {
    if (deviceType == 7) {
      return switch (coolerType) {
        2 => 'LINK H150i',
        5 => 'LINK H150i',
        _ => 'Unknown LINK H1XXI',
      };
    }

    return _baseNames[deviceType] ?? 'Unknown Device Type $deviceType';
  }
}

class CorsairLedPositionMap {
  static final Map<String, List<Vector3>> _rawPositions = <String, List<Vector3>>{
    'QX Fan': <Vector3>[
      Vector3(2, 0, 1),
      Vector3(3, 0, 0),
      Vector3(4, 0, 1),
      Vector3(5, 0, 2),
      Vector3(6, 0, 3),
      Vector3(5, 0, 4),
      Vector3(4, 0, 5),
      Vector3(3, 0, 6),
      Vector3(2, 0, 5),
      Vector3(1, 0, 4),
      Vector3(0, 0, 3),
      Vector3(1, 0, 2),
      Vector3(4, 0, 1),
      Vector3(3, 0, 0),
      Vector3(2, 0, 1),
      Vector3(1, 0, 2),
      Vector3(0, 0, 3),
      Vector3(1, 0, 4),
      Vector3(2, 0, 5),
      Vector3(3, 0, 6),
      Vector3(4, 0, 5),
      Vector3(5, 0, 4),
      Vector3(6, 0, 3),
      Vector3(5, 0, 2),
      Vector3(4, 0, 2),
      Vector3(5, 0, 3),
      Vector3(4, 0, 4),
      Vector3(2, 0, 4),
      Vector3(1, 0, 3),
      Vector3(2, 0, 2),
      Vector3(3, 0, 2),
      Vector3(2, 0, 3),
      Vector3(3, 0, 4),
      Vector3(4, 0, 3),
    ],
    'LINK H150i': <Vector3>[
      Vector3(6, 0, 4),
      Vector3(5, 0, 5),
      Vector3(4, 0, 6),
      Vector3(3, 0, 6),
      Vector3(2, 0, 6),
      Vector3(1, 0, 5),
      Vector3(0, 0, 4),
      Vector3(0, 0, 3),
      Vector3(0, 0, 2),
      Vector3(1, 0, 1),
      Vector3(2, 0, 0),
      Vector3(3, 0, 0),
      Vector3(4, 0, 0),
      Vector3(5, 0, 1),
      Vector3(6, 0, 2),
      Vector3(6, 0, 3),
      Vector3(3, 0, 2),
      Vector3(4, 0, 3),
      Vector3(3, 0, 4),
      Vector3(2, 0, 3),
    ],
    'LINK LCD': <Vector3>[
      Vector3(6, 0, 16),
      Vector3(4, 0, 15),
      Vector3(2, 0, 14),
      Vector3(1, 0, 12),
      Vector3(0, 0, 10),
      Vector3(0, 0, 8),
      Vector3(0, 0, 6),
      Vector3(1, 0, 4),
      Vector3(2, 0, 2),
      Vector3(4, 0, 1),
      Vector3(6, 0, 0),
      Vector3(8, 0, 0),
      Vector3(10, 0, 0),
      Vector3(12, 0, 1),
      Vector3(14, 0, 2),
      Vector3(15, 0, 4),
      Vector3(16, 0, 6),
      Vector3(16, 0, 8),
      Vector3(16, 0, 10),
      Vector3(15, 0, 12),
      Vector3(14, 0, 14),
      Vector3(12, 0, 15),
      Vector3(10, 0, 16),
      Vector3(8, 0, 16),
    ],
  };

  static final Map<String, Vector3> _deviceSizes = <String, Vector3>{
    'QX Fan': Vector3(7, 1, 7),
    'LINK H150i': Vector3(7, 1, 7),
    'LINK LCD': Vector3(17, 1, 17),
  };

  static List<Vector3> getLedPositions(String name) {
    final List<Vector3>? positions = _rawPositions[name];
    if (positions == null || positions.isEmpty) {
      return <Vector3>[];
    }

    return positions;
  }

  static Vector3 getSize(String name) {
    final Vector3? size = _deviceSizes[name];
    if (size == null) {
      return Vector3.zero();
    }

    return size;
  }
}

class CorsairDeviceDecoder {
  static List<SubComponent> decodeChildren(List<int> data) {
    final List<SubComponent> devices = <SubComponent>[];
    int i = 6;
    SubComponent? lcd;
    while (i < data.length - 34) {
      final int first = data[i];
      final int second = data[i + 1];
      final int third = data[i + 2];
      final int fourth = data[i + 3];
      final int fifth = data[i + 4];
      final int sixth = data[i + 5];
      if (first == 0x00 && second == 0x00 && third != 0x00 && fifth == 0x00 && sixth == 0x00) {
        final int type = third;
        final int cooler = fourth;
        final List<int> childDeviceID = data.sublist(i, i + 34);
        final List<int> idCharacterArray = <int>[];
        final List<int> uniqueCharacterArray = <int>[];
        for (int j = 8; j < childDeviceID.length; j++) {
          if (childDeviceID[j] == 0x00) {
            continue;
          } else if (j >= childDeviceID.length - 8) {
            uniqueCharacterArray.add(childDeviceID[j]);
          } else {
            idCharacterArray.add(childDeviceID[j]);
          }
        }

        final String idString = ascii.decode(idCharacterArray, allowInvalid: true);
        final String uniqueIdString = ascii.decode(uniqueCharacterArray, allowInvalid: true);
        final String name = CorsairDeviceNameMap.getDeviceName(type, cooler);
        final SubComponent subComponent = SubComponent(
          deviceType: type,
          coolerType: cooler,
          rawData: childDeviceID,
          deviceIDString: idString,
          uniqueIDString: uniqueIdString,
          name: name,
          ledPositions: CorsairLedPositionMap.getLedPositions(name),
          size: CorsairLedPositionMap.getSize(name),
        );
        if (type != 6) {
          devices.add(subComponent);
        } else {
          lcd = subComponent;
        }

        i += 31;
      } else {
        i++;
      }
    }

    return lcd == null
        ? devices
        : devices.expand((SubComponent device) sync* {
            yield device;
            if (device.deviceType == 7) {
              yield lcd!;
            }
          }).toList();
  }
}
