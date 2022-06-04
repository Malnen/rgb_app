import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid.dart';

class RightPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        child: ListView(
          controller: ScrollController(),
          children: [
            Column(
              children: <Widget>[
                EffectGrid(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
