import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

import '../models/device_data.dart';

class DevicesCubit extends HydratedCubit<List<DeviceData>> {
  DevicesCubit() : super([]);

  @override
  List<DeviceData> fromJson(Map<String, dynamic> json) {
    final List<dynamic> devicesData =
        json['devicesData'] as List<dynamic>;
    return devicesData.map(_map).toList();
  }

  @override
  Map<String, List<DeviceData>> toJson(List<DeviceData> state) {
    return {'devicesData': state};
  }

  void addDeviceData(DeviceData deviceData) {
    state.add(deviceData);
    emit(state);
  }

  void removeDeviceData(DeviceData deviceData) {
    state.remove(deviceData);
    emit(state);
  }

  DeviceData _map(dynamic entry) {
    final DeviceProductVendor deviceProductVendor =
        DeviceProductVendor.getType(entry['deviceProductVendor']['productVendor'] as String);
    return DeviceData(deviceProductVendor: deviceProductVendor);
  }
}
