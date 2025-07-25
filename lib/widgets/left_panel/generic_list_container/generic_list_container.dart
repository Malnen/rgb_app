import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/left_panel/add_generic_button/add_generic_button.dart';
import 'package:rgb_app/widgets/left_panel/generic_tile/generic_tile.dart';
import 'package:rgb_app/widgets/left_panel/remove_generic_button/remove_generic_button.dart';

class GenericListContainer<T> extends StatefulWidget {
  final List<T> values;
  final List<T> availableValues;
  final String Function(T value) getName;
  final String dialogLabel;
  final IconData Function(T value) getIcon;
  final void Function(T value) onAdd;
  final void Function(T value) onRemove;
  final bool Function(T value) isDisabled;
  final void Function(T value) onTap;
  final void Function(int oldIndex, int newIndex) onReorder;

  const GenericListContainer({
    required this.values,
    required this.getName,
    required this.getIcon,
    required this.onAdd,
    required this.onRemove,
    required this.isDisabled,
    required this.onTap,
    required this.onReorder,
    required this.availableValues,
    required this.dialogLabel,
  });

  @override
  State<StatefulWidget> createState() => _DevicesListContainer<T>();
}

class _DevicesListContainer<T> extends State<GenericListContainer<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: <Widget>[
          top(),
          list(),
        ],
      ),
    );
  }

  Widget top() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        right: 40,
        top: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AddGenericButton<T>(
            onTap: widget.onAdd,
            dialogLabel: widget.dialogLabel,
            getIcon: widget.getIcon,
            getName: widget.getName,
            values: widget.availableValues,
          ),
        ],
      ),
    );
  }

  Expanded list() {
    return Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 10, right: 20),
        child: ReorderableListView(
          buildDefaultDragHandles: false,
          onReorder: onReorder,
          children: <Widget>[
            ...getValues(),
          ],
        ),
      ),
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      widget.onReorder(oldIndex, newIndex);
    });
  }

  List<Widget> getValues() {
    return widget.values.asMap().entries.map(_buildDeviceRow).toList();
  }

  Widget _buildDeviceRow(MapEntry<int, T> entry) {
    final T value = entry.value;
    final int index = entry.key;

    return ReorderableDragStartListener(
      key: UniqueKey(),
      index: index,
      child: Row(
        children: <Widget>[
          GenericTile<T>(
            disabled: widget.isDisabled(value),
            value: value,
            onTap: widget.onTap,
            name: widget.getName(value),
            iconData: widget.getIcon(value),
          ),
          const SizedBox(
            width: 10,
          ),
          RemoveGenericButton<T>(
            value: value,
            onTap: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
