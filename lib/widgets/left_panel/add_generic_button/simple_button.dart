import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData? icon;

  const SimpleButton({
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Icon(icon ?? Icons.add),
      ),
      onTap: onTap,
    );
  }
}
