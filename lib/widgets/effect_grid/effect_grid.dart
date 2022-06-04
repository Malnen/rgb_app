import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_apply_button.dart';
import 'package:rgb_app/widgets/numeric_field/numeric_field.dart';

import '../../blocs/effects_bloc/effect_bloc.dart';
import 'effect_grid_container.dart';

class EffectGrid extends StatefulWidget {
  @override
  State<EffectGrid> createState() => _EffectGridState();
}

class _EffectGridState extends State<EffectGrid> {
  final TextEditingController controllerX = TextEditingController();
  final TextEditingController controllerY = TextEditingController();

  late EffectBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read();
    setControllersValue(bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: listener,
      bloc: bloc,
      child: Column(
        children: <Widget>[
          top(),
          EffectGridContainer(),
        ],
      ),
    );
  }

  void listener(BuildContext context, EffectState state) {
    setControllersValue(state);
  }

  void setControllersValue(EffectState state) {
    final EffectGridData effectGridData = state.effectGridData;
    final int sizeX = effectGridData.sizeX;
    final int sizeY = effectGridData.sizeY;

    controllerX.text = sizeX.toString();
    controllerY.text = sizeY.toString();
  }

  Row top() {
    return Row(
      children: <Widget>[
        NumericField(
          label: 'X',
          controller: controllerX,
        ),
        Container(
          width: 20,
          height: 20,
          child: Text(
            'x',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        NumericField(
          label: 'Y',
          controller: controllerY,
        ),
        EffectGridApplyButton(
          onTap: setGridSize,
        ),
      ],
    );
  }

  void setGridSize() {
    final int x = correctValue(controllerX);
    final int y = correctValue(controllerY);
    final SetGridSizeEvent event = SetGridSizeEvent(
      effectGridData: EffectGridData(
        sizeX: x,
        sizeY: y,
      ),
    );
    bloc.add(event);
  }

  int correctValue(TextEditingController controller) {
    final String text = controller.text;
    final bool hasText = text.isNotEmpty;
    final int parsedValue = hasText ? int.parse(text) : 0;
    if (parsedValue > 60) {
      controller.text = '60';
      return 60;
    } else if (parsedValue < 20) {
      controller.text = '20';
      return 20;
    }

    return parsedValue;
  }
}
