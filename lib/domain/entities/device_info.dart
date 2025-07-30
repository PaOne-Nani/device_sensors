class DeviceInfo {
  final String deviceName;
  final String osVersion;
  final int batteryLevel;

  const DeviceInfo({
    required this.deviceName,
    required this.osVersion,
    required this.batteryLevel,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfo &&
        other.deviceName == deviceName &&
        other.osVersion == osVersion &&
        other.batteryLevel == batteryLevel;
  }

  @override
  int get hashCode {
    return deviceName.hashCode ^
        osVersion.hashCode ^
        batteryLevel.hashCode;
  }

  @override
  String toString() {
    return 'DeviceInfo(deviceName: $deviceName, osVersion: $osVersion, batteryLevel: $batteryLevel)';
  }
} 