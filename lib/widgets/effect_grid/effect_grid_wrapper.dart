import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_container.dart';

class EffectGridWrapper extends StatefulWidget {
  @override
  State<EffectGridWrapper> createState() => _EffectGridWrapperState();
}

class _EffectGridWrapperState extends State<EffectGridWrapper> {
  late List<List<Color>> colors;
  late EffectBloc effectBloc;
  late EffectsColorsCubit effectsColorsCubit;

  @override
  void initState() {
    super.initState();
    effectBloc = GetIt.instance.get();
    colors = buildColors();
    effectsColorsCubit = GetIt.instance.get();
    effectsColorsCubit.updateColors(colors);
  }

  @override
  Widget build(BuildContext context) {
    context.select<EffectBloc, int>((EffectBloc value) => value.state.effectGridData.sizeX);
    context.select<EffectBloc, int>((EffectBloc value) => value.state.effectGridData.sizeY);
    colors = buildColors();

    return EffectGridContainer(
      colors: colors,
    );
  }

  List<List<Color>> buildColors() {
    final List<List<Color>> colors = <List<Color>>[];
    for (int i = 0; i < effectBloc.sizeY; i++) {
      final List<Color> colorRows = buildColorRows();
      colors.add(colorRows);
    }

    return colors;
  }

  List<Color> buildColorRows() {
    final List<Color> colors = <Color>[];
    for (int i = 0; i < effectBloc.sizeX; i++) {
      final Color color = Color.fromARGB(1, 255, 255, 255);
      colors.add(color);
    }

    return colors;
  }
}
