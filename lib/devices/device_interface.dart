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
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector3_property.dart';
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
  late BehaviorSubject<bool> isOpen;
  @protected
  late Vector3Property offsetProperty;
  @protected
  late Vector3Property scaleProperty;
  @protected
  late Vector3Property rotationProperty;

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

  List<Property<Object>> get properties => <Property<Object>>[offsetProperty, scaleProperty, rotationProperty];

  DeviceInterface({required DeviceData deviceData})
      : deviceDataNotifier = ValueNotifier<DeviceData>(deviceData),
        offsetProperty = Vector3Property(
          initialValue: vmath.Vector3(0, 0, 0),
          name: 'Offset',
          idn: 'offset',
          min: vmath.Vector3(0, 0, 0),
          max: vmath.Vector3(1000, 1000, 1000),
          precision: vmath.Vector3(2, 2, 2),
        ),
        scaleProperty = Vector3Property(
          initialValue: vmath.Vector3(1, 1, 1),
          name: 'Scale',
          idn: 'scale',
          min: vmath.Vector3(0.01, 0.01, 0.01),
          max: vmath.Vector3(1, 1, 1),
          precision: vmath.Vector3(3, 3, 3),
        ),
        rotationProperty = Vector3Property(
          initialValue: vmath.Vector3(0, 0, 0),
          name: 'Rotation',
          idn: 'rotation',
          min: vmath.Vector3(0, 0, 0),
          max: vmath.Vector3(360, 360, 360),
          precision: vmath.Vector3(0, 0, 0),
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
        DeviceProductVendor.corsairK70Lux => CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairK70MKIILowProfile => CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairK95Platinum => CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairICueLinkHub => CorsairICueLinkHub(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairVirtuoso => CorsairVirtuoso(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.steelSeriesRival100 => SteelSeriesRival100(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.steelSeriesRival3 => SteelSeriesRival3(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.auraLEDController => AuraLEDController(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
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

    offsetProperty.addValueChangeListener(_updateOffset);
    scaleProperty.addValueChangeListener(_updateScale);
    rotationProperty.addValueChangeListener(_updateRotation);
    subscribe(effectBloc.stream.listen(_recalculateProperties));
    _recalculateProperties(effectBloc.state);
    for (Property<Object?> property in properties) {
      property.enableDebounce();
    }
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
    if (offset.x != offsetProperty.x.value) {
      offsetProperty.x.value = offset.x;
    }

    if (offset.y != offsetProperty.y.value) {
      offsetProperty.y.value = offset.y;
    }

    if (offset.z != offsetProperty.z.value) {
      offsetProperty.z.value = offset.z;
    }
  }

  void _updateOffset(vmath.Vector3 value) {
    final vmath.Vector3 offset = deviceData.offset;
    if (offset.x != value.x || offset.y != value.y || offset.z != value.y) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        offset: offset.copyWith(x: value.x, y: value.y, z: value.z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _updateScaleProperties() {
    final vmath.Vector3 scale = deviceData.scale;
    if (scale.x != scaleProperty.x.value) {
      scaleProperty.x.value = scale.x;
    }

    if (scale.y != scaleProperty.y.value) {
      scaleProperty.y.value = scale.y;
    }

    if (scale.z != scaleProperty.z.value) {
      scaleProperty.z.value = scale.z;
    }
  }

  void _updateRotationProperties() {
    final vmath.Vector3 rotation = deviceData.rotation;
    if (rotation.x != rotationProperty.x.value) {
      rotationProperty.x.value = rotation.x;
    }

    if (rotation.y != rotationProperty.y.value) {
      rotationProperty.y.value = rotation.y;
    }

    if (rotation.z != rotationProperty.z.value) {
      rotationProperty.z.value = rotation.z;
    }
  }

  void _updateScale(vmath.Vector3 value) {
    final vmath.Vector3 scale = deviceData.scale;
    if (scale.x != value.x || scale.y != value.y || scale.z != value.y) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        scale: scale.copyWith(x: value.x, y: value.y, z: value.z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _updateRotation(vmath.Vector3 value) {
    final vmath.Vector3 rotation = deviceData.rotation;
    if (rotation.x != value.x || rotation.y != value.y || rotation.z != value.y) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        rotation: rotation.copyWith(x: value.x, y: value.y, z: value.z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _debounceRecalculateProperties() {
    _debounceRecalculatePropertiesTimer?.cancel();
    _debounceRecalculatePropertiesTimer = Timer(const Duration(milliseconds: 4), () => _recalculateProperties(effectBloc.state));
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

    final List<vmath.Vector3> transformedCorners = localCorners.map(rotationMatrix.transform3).toList();

    vmath.Vector3 minCorner = vmath.Vector3.copy(transformedCorners.first);
    vmath.Vector3 maxCorner = vmath.Vector3.copy(transformedCorners.first);

    for (final vmath.Vector3 corner in transformedCorners) {
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

    offsetProperty.x.min = minOffsetX;
    offsetProperty.y.min = minOffsetY;
    offsetProperty.z.min = minOffsetZ;

    offsetProperty.x.max = maxOffsetX;
    offsetProperty.y.max = maxOffsetY;
    offsetProperty.z.max = maxOffsetZ;

    offsetProperty.value = offsetProperty.value;
  }
}
