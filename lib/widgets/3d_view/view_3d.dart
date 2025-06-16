import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/widgets/3d_view/classes/view_painter_3d.dart';

class View3D extends StatefulHookWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const View3D({
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
  double rotationX = 0.0;
  double rotationY = 0.0;
  double zoomFactor = 40.0;

  @override
  Widget build(BuildContext context) {
    final DevicesBloc devicesBloc = GetIt.instance.get();
    useBlocBuilder(devicesBloc);

    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          GestureBinding.instance.pointerSignalResolver.register(
            event,
            (PointerSignalEvent e) {
              setState(() {
                zoomFactor *= (event.scrollDelta.dy > 0) ? .25 : 1.45;
                zoomFactor = zoomFactor.clamp(0.01, 2000);
              });
            },
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            rotationY += details.delta.dx * 0.01;
            rotationX += details.delta.dy * 0.01;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          color: widget.backgroundColor,
          child: CustomPaint(
            painter: ViewPainter3D(
              devices: devicesBloc.deviceInstances,
              rotationX: rotationX,
              rotationY: rotationY,
              zoomFactor: zoomFactor,
            ),
          ),
        ),
      ),
    );
  }
}
