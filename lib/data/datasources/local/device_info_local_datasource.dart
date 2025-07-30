import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/device_info_model.dart';

abstract class DeviceInfoLocalDataSource {
  Future<DeviceInfoModel> getLastDeviceInfo();
  Future<void> cacheDeviceInfo(DeviceInfoModel deviceInfo);
}

class DeviceInfoLocalDataSourceImpl implements DeviceInfoLocalDataSource {
  final SharedPreferences sharedPreferences;

  DeviceInfoLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<DeviceInfoModel> getLastDeviceInfo() async {
    try {
      final jsonString = sharedPreferences.getString('device_info');
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return DeviceInfoModel.fromJson(jsonMap);
      } else {
        throw CacheException('No cached device info found');
      }
    } catch (e) {
      throw CacheException('Failed to get cached device info: $e');
    }
  }

  @override
  Future<void> cacheDeviceInfo(DeviceInfoModel deviceInfo) async {
    try {
      final jsonString = json.encode(deviceInfo.toJson());
      await sharedPreferences.setString('device_info', jsonString);
    } catch (e) {
      throw CacheException('Failed to cache device info: $e');
    }
  }
} 