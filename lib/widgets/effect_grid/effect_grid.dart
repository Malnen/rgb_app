import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_apply_button.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_wrapper.dart';
import 'package:rgb_app/widgets/numeric_field/numeric_field.dart';

class EffectGrid extends StatefulWidget {
  @override
  State<EffectGrid> createState() => _EffectGridState();
}

class _EffectGridState extends State<EffectGrid> {
  final TextEditingController controllerX = TextEditingController();
  final TextEditingController controllerY = TextEditingController();

  late EffectBloc effectBloc;
  late EffectsColorsCubit effectsColorsCubit;

  @override
  void initState() {
    super.initState();
    effectBloc = GetIt.instance.get();
    effectsColorsCubit = GetIt.instance.get();
    setControllersValue();
  }

  @override
  Widget build(BuildContext context) {
    setGridSize();
    setControllersValue();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        top(),
        EffectGridWrapper(),
      ],
    );
  }

  Widget top() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          NumericField(
            label: 'X',
            controller: controllerX,
          ),
          SizedBox(
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
      ),
    );
  }

  void setGridSize() {
    final EffectState state = effectBloc.state;
    final EffectGridData effectGridData = state.effectGridData;
    final int minX = effectGridData.minSizeX;
    final int minY = effectGridData.minSizeY;
    final int x = correctValue(controllerX, minX);
    final int y = correctValue(controllerY, minY);
    final SetGridSizeEvent event = SetGridSizeEvent(
      effectGridData: effectGridData.copyWith(
        sizeX: x,
        sizeY: y,
      ),
    );
    effectBloc.add(event);
    effectsColorsCubit.updateColorsSize(x, y);
  }

  int correctValue(TextEditingController controller, int min) {
    final String text = controller.text;
    final bool hasText = text.isNotEmpty;
    final int parsedValue = hasText ? int.parse(text) : 0;
    if (parsedValue > 60) {
      controller.text = '60';
      return 60;
    } else if (parsedValue < min) {
      controller.text = min.toString();
      return min;
    }

    return parsedValue;
  }

  void setControllersValue() {
    final EffectState state = effectBloc.state;
    final EffectGridData effectGridData = state.effectGridData;
    final int sizeX = effectGridData.sizeX;
    final int sizeY = effectGridData.sizeY;

    controllerX.text = sizeX.toString();
    controllerY.text = sizeY.toString();
  }
}
