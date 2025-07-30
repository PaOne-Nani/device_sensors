import 'package:flutter/services.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/device_info_model.dart';

abstract class DeviceInfoRemoteDataSource {
  Future<DeviceInfoModel> getDeviceInfo();
  Future<String> getDeviceName();
  Future<String> getOSVersion();
  Future<int> getBatteryLevel();
}

class DeviceInfoRemoteDataSourceImpl implements DeviceInfoRemoteDataSource {
  static const MethodChannel _channel = MethodChannel('com.example.device_info/device');

  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
    try {
      final deviceName = await getDeviceName();
      final osVersion = await getOSVersion();
      final batteryLevel = await getBatteryLevel();

      return DeviceInfoModel(
        deviceName: deviceName,
        osVersion: osVersion,
        batteryLevel: batteryLevel,
      );
    } catch (e) {
      throw DeviceException('Failed to get device info: $e');
    }
  }

  @override
  Future<String> getDeviceName() async {
    try {
      final String deviceName = await _channel.invokeMethod('getDeviceName');
      return deviceName;
    } catch (e) {
      throw DeviceException('Failed to get device name: $e');
    }
  }

  @override
  Future<String> getOSVersion() async {
    try {
      final String osVersion = await _channel.invokeMethod('getOSVersion');
      return osVersion;
    } catch (e) {
      throw DeviceException('Failed to get OS version: $e');
    }
  }

  @override
  Future<int> getBatteryLevel() async {
    try {
      final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
      return batteryLevel;
    } catch (e) {
      throw DeviceException('Failed to get battery level: $e');
    }
  }
} 