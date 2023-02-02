import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';

class CurrentColorPresenter extends StatelessWidget {
  const CurrentColorPresenter();

  @override
  Widget build(BuildContext context) {
    final Color color = context.select<ColorPickerCubit, Color>((ColorPickerCubit cubit) => cubit.state.color);
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
