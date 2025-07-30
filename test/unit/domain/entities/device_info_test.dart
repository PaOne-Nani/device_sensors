import 'package:device_sensor/domain/entities/device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeviceInfo', () {
    test('should create a DeviceInfo instance with correct values', () {
      // Arrange
      const deviceName = 'Test Device';
      const osVersion = 'iOS 15.0';
      const batteryLevel = 85;

      // Act
      const deviceInfo = DeviceInfo(
        deviceName: deviceName,
        osVersion: osVersion,
        batteryLevel: batteryLevel,
      );

      // Assert
      expect(deviceInfo.deviceName, equals(deviceName));
      expect(deviceInfo.osVersion, equals(osVersion));
      expect(deviceInfo.batteryLevel, equals(batteryLevel));
    });

    test('should be equal when all properties are the same', () {
      // Arrange
      const deviceInfo1 = DeviceInfo(
        deviceName: 'Test Device',
        osVersion: 'iOS 15.0',
        batteryLevel: 85,
      );
      const deviceInfo2 = DeviceInfo(
        deviceName: 'Test Device',
        osVersion: 'iOS 15.0',
        batteryLevel: 85,
      );

      // Act & Assert
      expect(deviceInfo1, equals(deviceInfo2));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      const deviceInfo1 = DeviceInfo(
        deviceName: 'Test Device 1',
        osVersion: 'iOS 15.0',
        batteryLevel: 85,
      );
      const deviceInfo2 = DeviceInfo(
        deviceName: 'Test Device 2',
        osVersion: 'iOS 15.0',
        batteryLevel: 85,
      );

      // Act & Assert
      expect(deviceInfo1, isNot(equals(deviceInfo2)));
    });

    test('should have correct hashCode', () {
      // Arrange
      const deviceInfo1 = DeviceInfo(
        deviceName: 'Test Device',
        osVersion: 'iOS 15.0',
        batteryLevel: 85,
      );
      const deviceInfo2 = DeviceInfo(
        deviceName: 'Test Device',
        osVersion: 'iOS 15.0',
        batteryLevel: 85,
      );

      // Act & Assert
      expect(deviceInfo1.hashCode, equals(deviceInfo2.hashCode));
    });
  });
} 