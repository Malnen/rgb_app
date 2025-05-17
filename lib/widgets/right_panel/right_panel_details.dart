import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/widgets/device_configurator/device_configurator.dart';
import 'package:rgb_app/widgets/effect_configurator/effect_configurator.dart';

class RightPanelDetails extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Object?> rightPanelSelectionNotifier =
        GetIt.instance.get(instanceName: 'rightPanelSelectionNotifier');
    final Object? selectedValue = useValueListenable(rightPanelSelectionNotifier);

    return Column(
      children: <Widget>[
        if (selectedValue is DeviceInterface) DeviceConfigurator(),
        if (selectedValue is Effect) EffectConfigurator(),
      ],
    );
  }
}
