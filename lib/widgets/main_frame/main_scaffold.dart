import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_cubit.dart';
import 'package:rgb_app/services/loading_service.dart';
import 'package:rgb_app/utils/tick_provider.dart';
import 'package:rgb_app/widgets/left_panel/left_panel.dart';
import 'package:rgb_app/widgets/loading_barrier.dart';
import 'package:rgb_app/widgets/popup_wrapper/popup_wrapper.dart';
import 'package:rgb_app/widgets/rgb_app_service_logger/rgb_app_service_logger.dart';
import 'package:rgb_app/widgets/right_panel/right_panel.dart';

class MainScaffold extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final TickProvider tickProvider = GetIt.instance.get();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocProvider<PopupCubit>(
        create: (_) => PopupCubit(),
        child: PopupWrapper(
          child: Stack(
            children: <Widget>[
              Column(
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
              ),
              RgbAppServiceLogger(),
              ValueListenableBuilder<bool>(
                valueListenable: loadingService.isLoading,
                builder: (_, bool isLoading, __) => isLoading ? LoadingBarrier() : Container(),
              ),
              ValueListenableBuilder<int>(
                valueListenable: tickProvider.averageFps,
                builder: (_, int averageFps, __) {
                  return Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Color.fromRGBO(0, 0, 0, .24), blurRadius: 8, spreadRadius: 0),
                        ],
                      ),
                      child: Text(
                        '$averageFps',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
