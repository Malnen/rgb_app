import 'package:flutter/material.dart';

class EffectGridApplyButton extends StatefulWidget {
  final void Function() onTap;

  const EffectGridApplyButton({required this.onTap});

  @override
  State<EffectGridApplyButton> createState() => _EffectGridApplyButtonState();
}

class _EffectGridApplyButtonState extends State<EffectGridApplyButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 36,
        width: 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 16, 16, 16),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Apply',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
