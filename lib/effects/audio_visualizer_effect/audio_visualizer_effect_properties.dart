import 'package:flutter/material.dart';
import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/models/color_property.dart' as color;
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';

mixin AudioVisualizerEffectProperties {
  late NumericProperty audioGain;
  late NumericProperty boost;
  late NumericProperty pulseRate;
  late NumericProperty spectrumSize;
  late NumericProperty spectrumShift;
  late OptionProperty displayMode;
  late OptionProperty dynamicBoost;
  late color.ColorProperty barsColor;
  late color.ColorProperty backgroundColor;
  late OptionProperty barsColorMode;
  late OptionProperty disabledOnIdle;
  late OptionProperty backgroundColorMode;

  List<Property<Object>> get properties => <Property<Object>>[
        audioGain,
        boost,
        dynamicBoost,
        pulseRate,
        spectrumSize,
        spectrumShift,
        displayMode,
        disabledOnIdle,
        barsColorMode,
        barsColor,
        backgroundColorMode,
        backgroundColor,
      ];

  @protected
  void initProperties() {
    audioGain = NumericProperty(
      initialValue: 150,
      name: 'AudioGain',
      idn: 'audioGain',
      min: -200,
      max: 500,
      propertyType: NumericPropertyType.textField,
    );
    boost = NumericProperty(
      initialValue: -100,
      name: 'Boost',
      idn: 'boost',
      min: -200,
      max: 200,
    );
    pulseRate = NumericProperty(
      initialValue: 25,
      name: 'Pulse Rate',
      idn: 'pulseRate',
      min: 1,
      max: 50,
    );
    spectrumSize = NumericProperty(
      initialValue: 25,
      name: 'Spectrum Size',
      idn: 'spectrumSize',
      min: 1,
      max: 512,
    );
    spectrumShift = NumericProperty(
      initialValue: 25,
      name: 'Spectrum Shift',
      idn: 'spectrumShift',
      min: 0,
      max: 512,
    );
    barsColor = color.ColorProperty(
      initialValue: Colors.white,
      name: 'Bars Color',
      idn: 'barsColor',
    );
    backgroundColor = color.ColorProperty(
      initialValue: Colors.white,
      name: 'Background Color',
      idn: 'backgroundColor',
    );
    disabledOnIdle = OptionProperty(
      initialValue: <Option>{
        Option(
          value: 0,
          name: 'Yes',
          selected: false,
        ),
        Option(
          value: 1,
          name: 'No',
          selected: true,
        ),
      },
      name: 'Disable On Idle',
      idn: 'disabledOnIdle',
    );
    displayMode = OptionProperty(
      initialValue: <Option>{
        Option(
          value: 0,
          name: 'Bottom',
          selected: false,
        ),
        Option(
          value: 1,
          name: 'Middle',
          selected: true,
        ),
      },
      name: 'Display Mode',
      idn: 'displayMode',
    );
    barsColorMode = OptionProperty(
      initialValue: <Option>{
        Option(
          value: 0,
          name: 'Transparent',
          selected: false,
        ),
        Option(
          value: 1,
          name: 'Color',
          selected: true,
        ),
      },
      name: 'Bars Color Mode',
      idn: 'barsColorMode',
    );
    backgroundColorMode = OptionProperty(
      initialValue: <Option>{
        Option(
          value: 0,
          name: 'Transparent',
          selected: true,
        ),
        Option(
          value: 1,
          name: 'Color',
          selected: false,
        ),
      },
      name: 'Background Color Mode',
      idn: 'backgroundColorMode',
    );
    dynamicBoost = OptionProperty(
      initialValue: <Option>{
        Option(
          value: 0,
          name: 'On',
          selected: true,
        ),
        Option(
          value: 1,
          name: 'Off',
          selected: false,
        ),
      },
      name: 'Dynamic Boost',
      idn: 'dynamicBoost',
    );
  }
}
