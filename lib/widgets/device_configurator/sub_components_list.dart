import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/sub_device_interface.dart';

class SubComponentList extends StatelessWidget {
  final List<SubDeviceInterface> subComponents;

  const SubComponentList({required this.subComponents});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sub components',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: subComponents
                    .map(
                      (SubDeviceInterface subDevice) => InkWell(
                        onTap: () => GetIt.instance.get<DevicesBloc>().add(SelectDevicesEvent(device: subDevice)),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white10,
                          ),
                          child: Text(subDevice.subComponent.name),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
