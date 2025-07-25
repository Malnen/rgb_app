import 'package:flutter/material.dart';

class GenericTile<T> extends StatelessWidget {
  final T value;
  final IconData iconData;
  final String name;
  final void Function(T value) onTap;
  final bool disabled;

  GenericTile({
    required this.value,
    required this.iconData,
    required this.name,
    required this.onTap,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      margin: EdgeInsets.only(top: 6),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Material(
      color: disabled ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onTap(value),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            _icon(),
            _name(),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Icon(iconData),
    );
  }

  Widget _name() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
