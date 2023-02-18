import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_cubit.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_state.dart';
import 'package:rgb_app/widgets/popup_wrapper/drop_shape_painter.dart';

class PopupWrapper extends StatefulWidget {
  final Widget child;

  PopupWrapper({required this.child});

  @override
  State<PopupWrapper> createState() => _PopupWrapperState();
}

class _PopupWrapperState extends State<PopupWrapper> {
  final Size dropSize = Size.square(15);
  final Color backgroundColor = Color.fromARGB(255, 20, 20, 20);
  final double borderWidth = 2;

  late Offset offset;

  @override
  Widget build(BuildContext context) {
    final PopupCubit cubit = context.watch<PopupCubit>();
    final PopupState state = cubit.state;
    final bool show = state.show;

    return Stack(
      children: <Widget>[
        widget.child,
        if (show) ...getPopupContent(cubit),
      ],
    );
  }

  List<Widget> getPopupContent(PopupCubit cubit) {
    final PopupState state = cubit.state;
    final Offset offset = getPopupOffset(state);

    return <Widget>[
      getMask(cubit),
      getPopup(offset, state),
      getDrop(offset),
    ];
  }

  Widget getMask(PopupCubit cubit) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withAlpha(100),
      ),
      onTap: cubit.hide,
    );
  }

  Widget getPopup(Offset offset, PopupState state) {
    final Widget popupContent = state.popupContent!;
    final Offset padding = state.padding;
    final Size size = state.size;

    return Positioned(
      left: offset.dx + padding.dx,
      top: offset.dy + padding.dy,
      child: Center(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 20,
                blurRadius: 20,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: popupContent,
          ),
        ),
      ),
    );
  }

  Offset getPopupOffset(PopupState state) {
    final GlobalKey key = state.parentKey!;
    final BuildContext currentContext = key.currentContext!;
    final RenderBox renderBox = currentContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    return offset.translate(size.width / 2, -10);
  }

  Widget getDrop(Offset offset) {
    final double left = offset.dx - dropSize.width / 2;
    final double top = offset.dy - borderWidth;

    return Positioned(
      left: left,
      top: top,
      child: Padding(
        padding: EdgeInsets.only(top: borderWidth),
        child: CustomPaint(
          painter: DropShapePainter(
            color: backgroundColor,
            strokeColor: Colors.white,
            strokeWidth: borderWidth,
          ),
          size: dropSize,
        ),
      ),
    );
  }
}
