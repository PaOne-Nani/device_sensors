class SensorData {
  final bool isAccelerometerEnabled;
  final bool isGyroscopeEnabled;
  final bool isLightSensorEnabled;
  final double? accelerometerX;
  final double? accelerometerY;
  final double? accelerometerZ;
  final double? gyroscopeX;
  final double? gyroscopeY;
  final double? gyroscopeZ;
  final double? lightLevel;

  const SensorData({
    required this.isAccelerometerEnabled,
    required this.isGyroscopeEnabled,
    required this.isLightSensorEnabled,
    this.accelerometerX,
    this.accelerometerY,
    this.accelerometerZ,
    this.gyroscopeX,
    this.gyroscopeY,
    this.gyroscopeZ,
    this.lightLevel,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SensorData &&
        other.isAccelerometerEnabled == isAccelerometerEnabled &&
        other.isGyroscopeEnabled == isGyroscopeEnabled &&
        other.isLightSensorEnabled == isLightSensorEnabled &&
        other.accelerometerX == accelerometerX &&
        other.accelerometerY == accelerometerY &&
        other.accelerometerZ == accelerometerZ &&
        other.gyroscopeX == gyroscopeX &&
        other.gyroscopeY == gyroscopeY &&
        other.gyroscopeZ == gyroscopeZ &&
        other.lightLevel == lightLevel;
  }

  @override
  int get hashCode {
    return isAccelerometerEnabled.hashCode ^
        isGyroscopeEnabled.hashCode ^
        isLightSensorEnabled.hashCode ^
        accelerometerX.hashCode ^
        accelerometerY.hashCode ^
        accelerometerZ.hashCode ^
        gyroscopeX.hashCode ^
        gyroscopeY.hashCode ^
        gyroscopeZ.hashCode ^
        lightLevel.hashCode;
  }

  @override
  String toString() {
    return 'SensorData(isAccelerometerEnabled: $isAccelerometerEnabled, isGyroscopeEnabled: $isGyroscopeEnabled, isLightSensorEnabled: $isLightSensorEnabled, accelerometerX: $accelerometerX, accelerometerY: $accelerometerY, accelerometerZ: $accelerometerZ, gyroscopeX: $gyroscopeX, gyroscopeY: $gyroscopeY, gyroscopeZ: $gyroscopeZ, lightLevel: $lightLevel)';
  }
} 