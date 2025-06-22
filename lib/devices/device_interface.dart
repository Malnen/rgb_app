import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/devices/aura_led_controller/aura_led_controller.dart';
import 'package:rgb_app/devices/corsair_icue_link_hub/corsair_icue_link_hub.dart';
import 'package:rgb_app/devices/corsair_keyboard/corsair_keyboard.dart';
import 'package:rgb_app/devices/corsair_virtuoso/corsair_virtuoso.dart';
import 'package:rgb_app/devices/smbus/kingston/kingston_fury_ram.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/devices/steel_series_rival_3/steel_series_rival_3.dart';
import 'package:rgb_app/devices/udp_network_device_interface.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/extensions/color_list_extension.dart';
import 'package:rgb_app/extensions/vector_3_extension.dart';
import 'package:rgb_app/mixins/subscriber.dart';
import 'package:rgb_app/models/color_list.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/smbus/smbus.dart';
import 'package:rgb_app/utils/usb_device_data_sender/usb_device_data_sender.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vector_math/vector_math.dart' as vmath;

abstract class DeviceInterface with Subscriber {
  late EffectsColorsCubit effectsColorsCubit;
  late ValueNotifier<DeviceData> deviceDataNotifier;
  late Set<int> usedIndexes;

  @protected
  late EffectBloc effectBloc;
  @protected
  late DevicesBloc devicesBloc;
  @protected
  late BehaviorSubject<bool> isOpen;
  @protected
  late NumericProperty offsetXProperty;
  @protected
  late NumericProperty offsetYProperty;
  @protected
  late NumericProperty offsetZProperty;
  @protected
  late NumericProperty scaleXProperty;
  @protected
  late NumericProperty scaleYProperty;
  @protected
  late NumericProperty scaleZProperty;
  @protected
  late NumericProperty rotationXProperty;
  @protected
  late NumericProperty rotationYProperty;
  @protected
  late NumericProperty rotationZProperty;
  Timer? _debounceRecalculatePropertiesTimer;

  DeviceData get deviceData => deviceDataNotifier.value;

  set deviceData(DeviceData deviceData) {
    deviceDataNotifier.value = deviceData;
    _debounceRecalculateProperties();
  }

  int get offsetX => deviceData.offset.x.toInt();

  int get offsetY => deviceData.offset.y.toInt();

  int get offsetZ => deviceData.offset.z.toInt();

  vmath.Vector3 get scale => deviceData.scale;

  vmath.Vector3 get rotation => deviceData.rotation;

  List<Property<Object>> get properties => <Property<Object>>[
        offsetXProperty,
        offsetYProperty,
        offsetZProperty,
        scaleXProperty,
        scaleYProperty,
        scaleZProperty,
        rotationXProperty,
        rotationYProperty,
        rotationZProperty,
      ];

  DeviceInterface({required DeviceData deviceData})
      : deviceDataNotifier = ValueNotifier<DeviceData>(deviceData),
        offsetXProperty = NumericProperty(
          initialValue: 0,
          name: 'Offset X',
          idn: 'offsetX',
          min: 0,
          max: 1000,
          precision: 2,
        ),
        offsetYProperty = NumericProperty(
          initialValue: 0,
          name: 'Offset Y',
          idn: 'offsetY',
          min: 0,
          max: 1000,
          precision: 2,
        ),
        offsetZProperty = NumericProperty(
          initialValue: 0,
          name: 'Offset Z',
          idn: 'offsetZ',
          min: 0,
          max: 1000,
          precision: 2,
        ),
        scaleXProperty = NumericProperty(
          initialValue: 1,
          name: 'Scale X',
          idn: 'scaleX',
          min: 0.01,
          max: 1,
          precision: 3,
        ),
        scaleYProperty = NumericProperty(
          initialValue: 1,
          name: 'Scale Y',
          idn: 'scaleY',
          min: 0.01,
          max: 1,
          precision: 3,
        ),
        scaleZProperty = NumericProperty(
          initialValue: 1,
          name: 'Scale Z',
          idn: 'scaleZ',
          min: 0.01,
          max: 1,
          precision: 3,
        ),
        rotationXProperty = NumericProperty(
          initialValue: 0,
          name: 'Rotation X',
          idn: 'rotationX',
          min: 0,
          max: 360,
          precision: 0,
        ),
        rotationYProperty = NumericProperty(
          initialValue: 0,
          name: 'Rotation Y',
          idn: 'rotationY',
          min: 0,
          max: 360,
          precision: 0,
        ),
        rotationZProperty = NumericProperty(
          initialValue: 0,
          name: 'Rotation Z',
          idn: 'rotationZ',
          min: 0,
          max: 360,
          precision: 3,
        ),
        usedIndexes = <int>{} {
    effectBloc = GetIt.instance.get();
    devicesBloc = GetIt.instance.get();
    effectsColorsCubit = GetIt.instance.get();
    isOpen = BehaviorSubject<bool>();
  }

  static DeviceInterface fromDeviceData({
    required DeviceData deviceData,
    required UsbDeviceDataSender usbDeviceDataSender,
    required Smbus smbus,
  }) {
    if (deviceData is UsbDeviceData) {
      return switch (deviceData.deviceProductVendor.productVendor) {
        DeviceProductVendor.corsairK70Lux =>
          CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairK70MKIILowProfile =>
          CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairK95Platinum =>
          CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairICueLinkHub =>
          CorsairICueLinkHub(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairVirtuoso =>
          CorsairVirtuoso(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.steelSeriesRival100 =>
          SteelSeriesRival100(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.steelSeriesRival3 =>
          SteelSeriesRival3(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.auraLEDController =>
          AuraLEDController(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        _ => UnknownDevice(deviceData: deviceData),
      };
    } else if (deviceData is SMBusDeviceData) {
      if (deviceData.name == KingstonFuryRam.name) {
        return KingstonFuryRam(deviceData: deviceData, smbus: smbus);
      }
    } else if (deviceData is UdpNetworkDeviceData) {
      return UdpNetworkDeviceInterface(deviceData: deviceData);
    }

    throw Error();
  }

  @mustCallSuper
  Future<void> init() async {
    _updateOffsetProperties();
    _updateScaleProperties();
    _updateRotationProperties();
    for (Property<Object> property in properties) {
      property.addListener(onPropertyChanged);
      property.notify();
    }

    offsetXProperty.addValueChangeListener((double x) => _updateOffset(x: x));
    offsetYProperty.addValueChangeListener((double y) => _updateOffset(y: y));
    offsetZProperty.addValueChangeListener((double z) => _updateOffset(z: z));
    scaleXProperty.addValueChangeListener((double x) => _updateScale(x: x));
    scaleYProperty.addValueChangeListener((double y) => _updateScale(y: y));
    scaleZProperty.addValueChangeListener((double z) => _updateScale(z: z));
    rotationXProperty.addValueChangeListener((double x) => _updateRotation(x: x));
    rotationYProperty.addValueChangeListener((double y) => _updateRotation(y: y));
    rotationZProperty.addValueChangeListener((double z) => _updateRotation(z: z));
    subscribe(effectBloc.stream.listen(_recalculateProperties));
    _recalculateProperties(effectBloc.state);
    properties.whereType<NumericProperty>().forEach((NumericProperty property) => property.enableDebounce());
  }

  Future<void> dispose() async {
    await isOpen.close();
    unsubscribe();
  }

  void test();

  void update() {}

  void blink();

  vmath.Vector3 getSize();

  void updatePropertiesDeviceData() {
    for (Property<Object> property in properties) {
      final String idn = property.idn;
      final Property<Object>? deviceDataProperty = deviceData.properties.firstWhereOrNull(
        (Property<Object> deviceDataProperty) => idn == deviceDataProperty.idn,
      );
      if (deviceDataProperty != null) {
        property.updateProperty(deviceDataProperty);
      }
    }
  }

  @protected
  void onPropertyChanged() {
    final DeviceData updatedDeviceData = deviceData.copyWith(
      properties: properties,
      key: UniqueKey(),
    );
    final UpdateDeviceDataEvent event = UpdateDeviceDataEvent(deviceData: updatedDeviceData);
    devicesBloc.add(event);
  }

  @protected
  Color getColorAt({
    required int x,
    required int y,
    required int z,
    vmath.Vector3? offset,
    vmath.Vector3? scale,
    vmath.Vector3? rotation,
    vmath.Vector3? size,
  }) {
    scale ??= this.scale;
    offset ??= deviceData.offset;
    rotation ??= deviceData.rotation;
    size ??= getSize();
    final ColorList colors = effectsColorsCubit.colors;

    return colors.getTransformedColor(
      x: x,
      y: y,
      z: z,
      size: size,
      scale: scale,
      offset: offset,
      rotation: rotation,
    );
  }

  void _updateOffsetProperties() {
    final vmath.Vector3 offset = deviceData.offset;
    if (offset.x != offsetXProperty.value) {
      offsetXProperty.value = offset.x;
    }

    if (offset.y != offsetYProperty.value) {
      offsetYProperty.value = offset.y;
    }

    if (offset.z != offsetZProperty.value) {
      offsetZProperty.value = offset.z;
    }
  }

  void _updateOffset({double? x, double? y, double? z}) {
    final vmath.Vector3 offset = deviceData.offset;
    if (offset.x != x || offset.y != y || offset.z != z) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        offset: offset.copyWith(x: x, y: y, z: z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _updateScaleProperties() {
    final vmath.Vector3 scale = deviceData.scale;
    if (scale.x != scaleXProperty.value) {
      scaleXProperty.value = scale.x;
    }

    if (scale.y != scaleYProperty.value) {
      scaleYProperty.value = scale.y;
    }

    if (scale.z != scaleZProperty.value) {
      scaleZProperty.value = scale.z;
    }
  }

  void _updateRotationProperties() {
    final vmath.Vector3 rotation = deviceData.rotation;
    if (rotation.x != rotationXProperty.value) {
      rotationXProperty.value = rotation.x;
    }

    if (rotation.y != rotationYProperty.value) {
      rotationYProperty.value = rotation.y;
    }

    if (rotation.z != rotationZProperty.value) {
      rotationZProperty.value = rotation.z;
    }
  }

  void _updateScale({double? x, double? y, double? z}) {
    final vmath.Vector3 scale = deviceData.scale;
    if (scale.x != x || scale.y != y || scale.z != z) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        scale: scale.copyWith(x: x, y: y, z: z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _updateRotation({double? x, double? y, double? z}) {
    final vmath.Vector3 rotation = deviceData.rotation;
    if (rotation.x != x || rotation.y != y || rotation.z != z) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        rotation: rotation.copyWith(x: x, y: y, z: z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _debounceRecalculateProperties() {
    _debounceRecalculatePropertiesTimer?.cancel();
    _debounceRecalculatePropertiesTimer =
        Timer(const Duration(milliseconds: 4), () => _recalculateProperties(effectBloc.state));
  }

  void _recalculateProperties(EffectState effectState) {
    final vmath.Vector3 baseDeviceSize = getSize();

    final vmath.Vector3 scaledDeviceSize = vmath.Vector3(
      baseDeviceSize.x * scale.x,
      baseDeviceSize.y * scale.y,
      baseDeviceSize.z * scale.z,
    );

    final double rotationXRadians = vmath.radians(rotation.x % 360);
    final double rotationYRadians = vmath.radians(rotation.y % 360);
    final double rotationZRadians = vmath.radians(rotation.z % 360);

    final vmath.Vector3 center = scaledDeviceSize / 2;

    final vmath.Matrix4 rotationMatrix = vmath.Matrix4.identity()
      ..translate(center.x, center.y, center.z)
      ..rotateX(rotationXRadians)
      ..rotateY(rotationYRadians)
      ..rotateZ(rotationZRadians)
      ..translate(-center.x, -center.y, -center.z);

    final List<vmath.Vector3> localCorners = <vmath.Vector3>[
      vmath.Vector3.zero(),
      vmath.Vector3(scaledDeviceSize.x, 0, 0),
      vmath.Vector3(0, scaledDeviceSize.y, 0),
      vmath.Vector3(0, 0, scaledDeviceSize.z),
      vmath.Vector3(scaledDeviceSize.x, scaledDeviceSize.y, 0),
      vmath.Vector3(0, scaledDeviceSize.y, scaledDeviceSize.z),
      vmath.Vector3(scaledDeviceSize.x, 0, scaledDeviceSize.z),
      vmath.Vector3(scaledDeviceSize.x, scaledDeviceSize.y, scaledDeviceSize.z),
    ];

    final List<vmath.Vector3> transformedCorners =
        localCorners.map((corner) => rotationMatrix.transform3(corner)).toList();

    vmath.Vector3 minCorner = vmath.Vector3.copy(transformedCorners.first);
    vmath.Vector3 maxCorner = vmath.Vector3.copy(transformedCorners.first);

    for (final corner in transformedCorners) {
      minCorner = vmath.Vector3(
        corner.x < minCorner.x ? corner.x : minCorner.x,
        corner.y < minCorner.y ? corner.y : minCorner.y,
        corner.z < minCorner.z ? corner.z : minCorner.z,
      );

      maxCorner = vmath.Vector3(
        corner.x > maxCorner.x ? corner.x : maxCorner.x,
        corner.y > maxCorner.y ? corner.y : maxCorner.y,
        corner.z > maxCorner.z ? corner.z : maxCorner.z,
      );
    }

    final double minOffsetX = -minCorner.x;
    final double minOffsetY = -minCorner.y;
    final double minOffsetZ = -minCorner.z;

    final double maxOffsetX = effectState.effectGridData.size.x - maxCorner.x;
    final double maxOffsetY = effectState.effectGridData.size.y - maxCorner.y;
    final double maxOffsetZ = effectState.effectGridData.size.z - maxCorner.z;

    offsetXProperty.min = minOffsetX;
    offsetYProperty.min = minOffsetY;
    offsetZProperty.min = minOffsetZ;

    offsetXProperty.max = maxOffsetX;
    offsetYProperty.max = maxOffsetY;
    offsetZProperty.max = maxOffsetZ;

    offsetXProperty.value = offsetXProperty.value;
    offsetYProperty.value = offsetYProperty.value;
    offsetZProperty.value = offsetZProperty.value;
  }
}
