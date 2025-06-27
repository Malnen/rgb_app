import 'package:flutter/material.dart';

class EffectGridApplyButton extends StatefulWidget {
  final VoidCallback onTap;

  const EffectGridApplyButton({required this.onTap});

  @override
  State<EffectGridApplyButton> createState() => _EffectGridApplyButtonState();
}

class _EffectGridApplyButtonState extends State<EffectGridApplyButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 36,
        width: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Apply',
          ),
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
