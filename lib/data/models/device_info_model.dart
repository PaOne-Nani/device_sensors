import '../../domain/entities/device_info.dart';

class DeviceInfoModel extends DeviceInfo {
  const DeviceInfoModel({
    required String deviceName,
    required String osVersion,
    required int batteryLevel,
  }) : super(
          deviceName: deviceName,
          osVersion: osVersion,
          batteryLevel: batteryLevel,
        );

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) {
    return DeviceInfoModel(
      deviceName: json['deviceName'] ?? '',
      osVersion: json['osVersion'] ?? '',
      batteryLevel: json['batteryLevel'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceName': deviceName,
      'osVersion': osVersion,
      'batteryLevel': batteryLevel,
    };
  }

  factory DeviceInfoModel.fromEntity(DeviceInfo entity) {
    return DeviceInfoModel(
      deviceName: entity.deviceName,
      osVersion: entity.osVersion,
      batteryLevel: entity.batteryLevel,
    );
  }
} 