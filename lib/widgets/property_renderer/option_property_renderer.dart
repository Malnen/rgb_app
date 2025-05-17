import 'package:flutter/material.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/widgets/property_renderer/option_tile.dart';

class OptionPropertyRenderer extends StatefulWidget {
  final OptionProperty property;
  final VoidCallback? updateRenderer;

  const OptionPropertyRenderer({
    required this.property,
    this.updateRenderer,
  });

  @override
  State<OptionPropertyRenderer> createState() => _OptionPropertyRendererState();
}

class _OptionPropertyRendererState extends State<OptionPropertyRenderer> {
  OptionProperty get property => widget.property;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 20),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orange,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Row(
          children: property.value
              .map(
                (Option option) => OptionTile(
                  option: option,
                  onTap: onTap,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void onTap(Option tappedOption) {
    if (!tappedOption.selected) {
      final Set<Option> newOptions = <Option>{};
      for (Option option in property.value) {
        final Option newOption = option.copyWith(selected: tappedOption == option);
        newOptions.add(newOption);
      }

      property.value = newOptions;
      widget.updateRenderer?.call();
      setState(() {});
    }
  }
}
