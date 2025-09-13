import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/sub_device_interface.dart';

class SubComponentList extends StatelessWidget {
  final List<SubDeviceInterface> subComponents;

  const SubComponentList({required this.subComponents, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: subComponents.map(
                    (SubDeviceInterface subDevice) {
                      return InkWell(
                        onTap: () => GetIt.instance.get<DevicesBloc>().add(SelectDevicesEvent(device: subDevice)),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.surfaceBright,
                          ),
                          child: Text(
                            subDevice.subComponent.name,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              Positioned(
                left: 12,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  color: Theme.of(context).colorScheme.surface,
                  child: const Text(
                    'Sub components',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
