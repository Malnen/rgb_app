import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/dialogs/dialog_manager.dart';
import 'package:rgb_app/widgets/left_panel/generic_tile/generic_tile.dart';

class AddGenericButton<T> extends StatefulWidget {
  final void Function(T value) onTap;
  final String dialogLabel;
  final List<T> values;
  final String Function(T value) getName;
  final IconData Function(T value) getIcon;

  const AddGenericButton({
    required this.onTap,
    required this.dialogLabel,
    required this.values,
    required this.getName,
    required this.getIcon,
  });

  @override
  State<AddGenericButton<T>> createState() => _AddGenericButtonState<T>();
}

class _AddGenericButtonState<T> extends State<AddGenericButton<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 16, 16, 16),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      onTap: _onTap,
    );
  }

  void _onTap() {
    Navigator.of(context).push(
      DialogManager.showDialog(
        context: context,
        title: widget.dialogLabel,
        child: Column(
          children: <Widget>[
            ...widget.values.map(
              (final T value) => GenericTile<T>(
                disabled: false,
                value: value,
                onTap: _addEvent,
                iconData: widget.getIcon(value),
                name: widget.getName(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent(final T value) {
    widget.onTap(value);
    Navigator.of(context).pop();
  }
}
