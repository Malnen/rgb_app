import 'package:flutter/material.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/widgets/effect_property_renderer/option_tile.dart';

class OptionPropertyRenderer extends StatefulWidget {
  final OptionProperty property;

  const OptionPropertyRenderer({required this.property});

  @override
  State<OptionPropertyRenderer> createState() => _OptionPropertyRendererState();
}

class _OptionPropertyRendererState extends State<OptionPropertyRenderer> {
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
          children: widget.property.value
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
      for (Option option in widget.property.value) {
        final Option newOption = option.copyWith(selected: tappedOption == option);
        newOptions.add(newOption);
      }

      widget.property.value = newOptions;
      widget.property.onChange(newOptions);
      setState(() {});
    }
  }
}
