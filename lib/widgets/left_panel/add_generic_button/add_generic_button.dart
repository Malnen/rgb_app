import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/dialogs/dialog_manager.dart';
import 'package:rgb_app/widgets/left_panel/add_generic_button/simple_button.dart';
import 'package:rgb_app/widgets/left_panel/generic_tile/generic_tile.dart';

class AddGenericButton<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SimpleButton(onTap: () => _onTap(context));
  }

  void _onTap(BuildContext context) {
    Navigator.of(context).push(
      DialogManager.showDialog<void>(
        context: context,
        title: dialogLabel,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: <Widget>[
              ...values.map(
                (T value) => GenericTile<T>(
                  disabled: false,
                  value: value,
                  onTap: (T value) => _addEvent(value, context),
                  iconData: getIcon(value),
                  name: getName(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEvent(T value, BuildContext context) {
    onTap(value);
    Navigator.of(context).pop();
  }
}
