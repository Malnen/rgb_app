import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_cubit.dart';
import 'package:rgb_app/widgets/left_panel/left_panel.dart';
import 'package:rgb_app/widgets/popup_wrapper/popup_wrapper.dart';
import 'package:rgb_app/widgets/right_panel/right_panel.dart';

class MainScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<PopupCubit>(
        create: (_) => PopupCubit(),
        child: PopupWrapper(
          child: _body(),
        ),
      ),
    );
  }

  Column _body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              LeftPanel(),
              RightPanel(),
            ],
          ),
        ),
      ],
    );
  }
}
