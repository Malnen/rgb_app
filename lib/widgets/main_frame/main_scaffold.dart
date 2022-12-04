import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/left_panel/left_panel.dart';
import 'package:rgb_app/widgets/right_panel/right_panel.dart';

class MainScaffold extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _body(),
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
