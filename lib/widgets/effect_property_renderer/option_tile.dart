import 'package:flutter/material.dart';
import 'package:rgb_app/models/option.dart';

class OptionTile extends StatelessWidget {
  final Option option;
  final void Function(Option) onTap;

  const OptionTile({
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        color: option.selected ? Colors.orange : Colors.transparent,
        child: Text(
          option.name,
          style: TextStyle(
            color: option.selected ? Colors.white : Colors.orange,
          ),
        ),
      ),
      onTap: () => onTap(option),
    );
  }
}
