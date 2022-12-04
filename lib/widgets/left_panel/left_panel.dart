import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/devices_list_container.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/effects_list_container.dart';

class LeftPanel extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object>>>[
        BlocProvider<DevicesBloc>.value(
          value: GetIt.instance.get(),
        ),
        BlocProvider<EffectBloc>.value(
          value: GetIt.instance.get(),
        ),
      ],
      child: Container(
        width: 380,
        decoration: _getBoxDecoration(),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Theme
                .of(context)
                .backgroundColor,
            appBar: AppBar(
              flexibleSpace: const TabBar(
                indicatorColor: Colors.orange,
                tabs: <Tab>[
                  Tab(icon: Icon(Icons.devices), text: 'Devices'),
                  Tab(icon: Icon(Icons.blur_linear), text: 'Effects'),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                DevicesListContainer(),
                EffectsListContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 3),
        ),
      ],
    );
  }
}
