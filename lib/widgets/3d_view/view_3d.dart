import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/lightning_controller_interface.dart';
import 'package:rgb_app/utils/tick_provider.dart';
import 'package:rgb_app/widgets/3d_view/classes/view_painter_3d.dart';

class View3D extends StatefulHookWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final ValueNotifier<bool> showEffects;

  const View3D({
    required this.showEffects,
    super.key,
    this.width = 250,
    this.height = 250,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<View3D> createState() => _View3DState();
}

class _View3DState extends State<View3D> {
  double rotationX = .5;
  double rotationY = .6;
  double zoomFactor = 3;
  Offset translationOffset = Offset(-50, 0);
  bool isPanning = false;
  int? activePointerButton;

  @override
  void initState() {
    final TickProvider tickProvider = GetIt.instance.get();
    tickProvider.onTick(() async => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DevicesBloc devicesBloc = GetIt.instance.get();
    useBlocBuilder(devicesBloc);

    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if (event.kind == PointerDeviceKind.mouse) {
          activePointerButton = event.buttons;
          isPanning = event.buttons == kSecondaryMouseButton;
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        setState(() {
          if (isPanning) {
            translationOffset += Offset(event.delta.dx, -event.delta.dy) * 0.1;
          } else if (activePointerButton == kPrimaryMouseButton) {
            rotationY += event.delta.dx * 0.01;
            rotationX += event.delta.dy * 0.01;
          }
        });
      },
      onPointerUp: (_) {
        isPanning = false;
        activePointerButton = null;
      },
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          GestureBinding.instance.pointerSignalResolver.register(
            event,
            (PointerSignalEvent e) {
              setState(() {
                zoomFactor += zoomFactor * ((event.scrollDelta.dy > 0) ? -.1 : .1);
                zoomFactor = zoomFactor.clamp(1, 8);
              });
            },
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          color: widget.backgroundColor,
          child: CustomPaint(
            painter: ViewPainter3D(
              showEffects: widget.showEffects.value,
              devices: devicesBloc.deviceInstances.expand(
                (DeviceInterface deviceInterface) {
                  final bool isLightningController = deviceInterface is LightningControllerInterface;
                  return <DeviceInterface>[
                    if (!isLightningController) deviceInterface,
                    if (isLightningController) ...deviceInterface.subDevices,
                  ];
                },
              ).toList(),
              rotationX: rotationX,
              rotationY: rotationY,
              zoomFactor: zoomFactor,
              translationOffset: translationOffset,
            ),
          ),
        ),
      ),
    );
  }
}
