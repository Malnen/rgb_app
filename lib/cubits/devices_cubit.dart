import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

import '../models/device_data.dart';
import 'device_data_state.dart';

class DevicesCubit extends HydratedCubit<DevicesDataState> {
  DevicesCubit()
      : super(
          DevicesDataState(
            devicesData: [],
          ),
        );

  @override
  DevicesDataState fromJson(Map<String, dynamic> json) {
    final DevicesDataState state = DevicesDataState.fromJson(
      json['devicesDataState'] as Map<String, dynamic>,
    );
    final List<DeviceData> devicesData = state.devicesData;
    return DevicesDataState(
      devicesData: devicesData,
    );
  }

  @override
  Map<String, DevicesDataState> toJson(DevicesDataState state) {
    return {'devicesDataState': state};
  }

  void addDeviceData(DeviceData deviceData) {
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceProductVendor deviceProductVendor =
        deviceData.deviceProductVendor;
    final String productVendor = deviceProductVendor.productVendor;
    final bool hasDevice = devicesData.any((DeviceData element) =>
        element.deviceProductVendor.productVendor == productVendor);
    if (!hasDevice) {
      devicesData.add(deviceData);
      final DevicesDataState newState = DevicesDataState(
        devicesData: state.devicesData,
      );
      emit(newState);
    }
  }

  void removeDeviceData(DeviceData deviceData) {
    final DeviceProductVendor deviceProductVendor =
        deviceData.deviceProductVendor;
    final String productVendor = deviceProductVendor.productVendor;
    final List<DeviceData> devicesData = state.devicesData;
    devicesData.removeWhere((DeviceData element) =>
        element.deviceProductVendor.productVendor == productVendor);
    final DevicesDataState newState = DevicesDataState(
      devicesData: state.devicesData,
    );
    emit(newState);
  }
}
