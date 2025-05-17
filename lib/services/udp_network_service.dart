import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/udp_network_device_details.dart';

class UdpNetworkService {
  final FlutterNsd _nsd;
  final StreamController<UdpNetworkDeviceData> _controller;

  UdpNetworkService()
      : _nsd = FlutterNsd(),
        _controller = StreamController<UdpNetworkDeviceData>.broadcast();

  Stream<UdpNetworkDeviceData> get discoveredDevices => _controller.stream;

  void startDiscovery() async {
    _nsd.stream.listen((NsdServiceInfo service) async {
      if (service.hostname != null && service.port != null) {
        final InternetAddress? address = await _resolveHost(service.hostname!);
        if (address != null) {
          final Map<String, Uint8List> text = service.txt ?? <String, Uint8List>{};
          final String name = text.containsKey('name') ? utf8.decode(text['name']!) : '';
          final String id = text.containsKey('id') ? utf8.decode(text['id']!) : '';
          final UdpNetworkDeviceData deviceData = UdpNetworkDeviceData(
            udpNetworkDeviceDetails: UdpNetworkDeviceDetails(
              id: id,
              name: name,
              address: service.hostname,
              port: service.port!,
            ),
            key: UniqueKey(),
          );
          _controller.add(deviceData);
          final DevicesBloc devicesBloc = GetIt.instance.get();
          devicesBloc.add(AddAvailableDeviceEvent(deviceData));
        }
      }
    });

    await _nsd.discoverServices('_rgbapp._udp.');
  }

  Future<InternetAddress?> _resolveHost(String hostname) async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup(hostname);
      return result.isNotEmpty ? result.first : null;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _controller.close();
  }
}
