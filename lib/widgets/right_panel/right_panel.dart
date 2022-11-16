import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid.dart';

class RightPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EffectBloc>.value(
      value: GetIt.instance.get(),
      child: _body(),
    );
  }

  Flexible _body() {
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
