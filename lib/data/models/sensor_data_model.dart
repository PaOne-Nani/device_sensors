import '../../domain/entities/sensor_data.dart';

class SensorDataModel extends SensorData {
  const SensorDataModel({
    required bool isAccelerometerEnabled,
    required bool isGyroscopeEnabled,
    required bool isLightSensorEnabled,
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    double? gyroscopeX,
    double? gyroscopeY,
    double? gyroscopeZ,
    double? lightLevel,
  }) : super(
          isAccelerometerEnabled: isAccelerometerEnabled,
          isGyroscopeEnabled: isGyroscopeEnabled,
          isLightSensorEnabled: isLightSensorEnabled,
          accelerometerX: accelerometerX,
          accelerometerY: accelerometerY,
          accelerometerZ: accelerometerZ,
          gyroscopeX: gyroscopeX,
          gyroscopeY: gyroscopeY,
          gyroscopeZ: gyroscopeZ,
          lightLevel: lightLevel,
        );

  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      isAccelerometerEnabled: json['isAccelerometerEnabled'] ?? false,
      isGyroscopeEnabled: json['isGyroscopeEnabled'] ?? false,
      isLightSensorEnabled: json['isLightSensorEnabled'] ?? false,
      accelerometerX: json['accelerometerX']?.toDouble(),
      accelerometerY: json['accelerometerY']?.toDouble(),
      accelerometerZ: json['accelerometerZ']?.toDouble(),
      gyroscopeX: json['gyroscopeX']?.toDouble(),
      gyroscopeY: json['gyroscopeY']?.toDouble(),
      gyroscopeZ: json['gyroscopeZ']?.toDouble(),
      lightLevel: json['lightLevel']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAccelerometerEnabled': isAccelerometerEnabled,
      'isGyroscopeEnabled': isGyroscopeEnabled,
      'isLightSensorEnabled': isLightSensorEnabled,
      'accelerometerX': accelerometerX,
      'accelerometerY': accelerometerY,
      'accelerometerZ': accelerometerZ,
      'gyroscopeX': gyroscopeX,
      'gyroscopeY': gyroscopeY,
      'gyroscopeZ': gyroscopeZ,
      'lightLevel': lightLevel,
    };
  }

  factory SensorDataModel.fromEntity(SensorData entity) {
    return SensorDataModel(
      isAccelerometerEnabled: entity.isAccelerometerEnabled,
      isGyroscopeEnabled: entity.isGyroscopeEnabled,
      isLightSensorEnabled: entity.isLightSensorEnabled,
      accelerometerX: entity.accelerometerX,
      accelerometerY: entity.accelerometerY,
      accelerometerZ: entity.accelerometerZ,
      gyroscopeX: entity.gyroscopeX,
      gyroscopeY: entity.gyroscopeY,
      gyroscopeZ: entity.gyroscopeZ,
      lightLevel: entity.lightLevel,
    );
  }
} 