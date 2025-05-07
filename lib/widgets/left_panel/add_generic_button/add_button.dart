import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData? icon;

  const AddButton({
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
          color: Color.fromARGB(255, 16, 16, 16),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Icon(
          icon ?? Icons.add,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}
