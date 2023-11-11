import 'package:flutter/material.dart';

class ColorPosition extends StatefulWidget {
  final void Function(GlobalKey, int) onTap;
  final VoidCallback onDelete;
  final Color color;
  final int index;

  const ColorPosition({
    required this.onTap,
    required this.onDelete,
    required this.color,
    required this.index,
  });

  @override
  State<ColorPosition> createState() => _ColorPositionState();
}

class _ColorPositionState extends State<ColorPosition> {
  final double deleteButtonSize = 12;

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setHoverState(true),
      onExit: (_) => setHoverState(false),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            getColorPresenter(),
            if (hover) getDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget getColorPresenter() {
    final GlobalKey globalKey = GlobalKey();
    return InkWell(
      child: Container(
        width: 30,
        height: 30,
        key: globalKey,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
        ),
      ),
      onTap: () => widget.onTap(globalKey, widget.index),
    );
  }

  Widget getDeleteButton() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: InkWell(
        child: Container(
          width: deleteButtonSize,
          height: deleteButtonSize,
          color: Colors.orange,
          child: Icon(
            Icons.close,
            size: deleteButtonSize,
          ),
        ),
        onTap: widget.onDelete,
      ),
    );
  }

  void setHoverState(bool hover) {
    setState(() {
      this.hover = hover;
    });
  }
}
