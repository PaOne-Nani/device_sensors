import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_sensor/data/datasources/remote/device_info_remote_datasource.dart';
import 'package:device_sensor/core/errors/exceptions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceInfoRemoteDataSource Platform Channel Tests', () {
    const MethodChannel channel = MethodChannel('com.example.device_info/device');
    late DeviceInfoRemoteDataSourceImpl dataSource;

    setUp(() {
      dataSource = DeviceInfoRemoteDataSourceImpl();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      );
    });

    test('getDeviceName should return device name from platform channel', () async {
      // Arrange
      const expectedDeviceName = 'iPhone 14 Pro';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async {
          if (methodCall.method == 'getDeviceName') {
            return expectedDeviceName;
          }
          return null;
        },
      );

      // Act
      final result = await dataSource.getDeviceName();

      // Assert
      expect(result, equals(expectedDeviceName));
    });

    test('getOSVersion should return OS version from platform channel', () async {
      // Arrange
      const expectedOSVersion = 'iOS 16.0';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async {
          if (methodCall.method == 'getOSVersion') {
            return expectedOSVersion;
          }
          return null;
        },
      );

      // Act
      final result = await dataSource.getOSVersion();

      // Assert
      expect(result, equals(expectedOSVersion));
    });

    test('getBatteryLevel should return battery level from platform channel', () async {
      // Arrange
      const expectedBatteryLevel = 75;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async {
          if (methodCall.method == 'getBatteryLevel') {
            return expectedBatteryLevel;
          }
          return null;
        },
      );

      // Act
      final result = await dataSource.getBatteryLevel();

      // Assert
      expect(result, equals(expectedBatteryLevel));
    });

    test('getDeviceInfo should return complete device info', () async {
      // Arrange
      const expectedDeviceName = 'iPhone 14 Pro';
      const expectedOSVersion = 'iOS 16.0';
      const expectedBatteryLevel = 75;
      
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getDeviceName':
              return expectedDeviceName;
            case 'getOSVersion':
              return expectedOSVersion;
            case 'getBatteryLevel':
              return expectedBatteryLevel;
            default:
              return null;
          }
        },
      );

      // Act
      final result = await dataSource.getDeviceInfo();

      // Assert
      expect(result.deviceName, equals(expectedDeviceName));
      expect(result.osVersion, equals(expectedOSVersion));
      expect(result.batteryLevel, equals(expectedBatteryLevel));
    });

    test('should throw DeviceException when platform channel fails', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (MethodCall methodCall) async {
          throw PlatformException(code: 'ERROR', message: 'Platform error');
        },
      );

      // Act & Assert
      expect(
        () => dataSource.getDeviceName(),
        throwsA(isA<DeviceException>()),
      );
    });
  });
} 