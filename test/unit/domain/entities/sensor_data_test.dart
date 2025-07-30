import 'package:device_sensor/domain/entities/sensor_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SensorData', () {
    test('should create a SensorData instance with correct values', () {
      // Arrange
      const isAccelerometerEnabled = true;
      const isGyroscopeEnabled = false;
      const isLightSensorEnabled = true;
      const accelerometerX = 0.5;
      const accelerometerY = -0.2;
      const accelerometerZ = 9.8;
      const gyroscopeX = 0.1;
      const gyroscopeY = 0.05;
      const gyroscopeZ = -0.02;
      const lightLevel = 500.0;

      // Act
      const sensorData = SensorData(
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

      // Assert
      expect(sensorData.isAccelerometerEnabled, equals(isAccelerometerEnabled));
      expect(sensorData.isGyroscopeEnabled, equals(isGyroscopeEnabled));
      expect(sensorData.isLightSensorEnabled, equals(isLightSensorEnabled));
      expect(sensorData.accelerometerX, equals(accelerometerX));
      expect(sensorData.accelerometerY, equals(accelerometerY));
      expect(sensorData.accelerometerZ, equals(accelerometerZ));
      expect(sensorData.gyroscopeX, equals(gyroscopeX));
      expect(sensorData.gyroscopeY, equals(gyroscopeY));
      expect(sensorData.gyroscopeZ, equals(gyroscopeZ));
      expect(sensorData.lightLevel, equals(lightLevel));
    });

    test('should create a SensorData instance with null sensor values', () {
      // Arrange
      const isAccelerometerEnabled = false;
      const isGyroscopeEnabled = false;
      const isLightSensorEnabled = false;

      // Act
      const sensorData = SensorData(
        isAccelerometerEnabled: isAccelerometerEnabled,
        isGyroscopeEnabled: isGyroscopeEnabled,
        isLightSensorEnabled: isLightSensorEnabled,
      );

      // Assert
      expect(sensorData.isAccelerometerEnabled, equals(isAccelerometerEnabled));
      expect(sensorData.isGyroscopeEnabled, equals(isGyroscopeEnabled));
      expect(sensorData.isLightSensorEnabled, equals(isLightSensorEnabled));
      expect(sensorData.accelerometerX, isNull);
      expect(sensorData.accelerometerY, isNull);
      expect(sensorData.accelerometerZ, isNull);
      expect(sensorData.gyroscopeX, isNull);
      expect(sensorData.gyroscopeY, isNull);
      expect(sensorData.gyroscopeZ, isNull);
      expect(sensorData.lightLevel, isNull);
    });

    test('should be equal when all properties are the same', () {
      // Arrange
      const sensorData1 = SensorData(
        isAccelerometerEnabled: true,
        isGyroscopeEnabled: false,
        isLightSensorEnabled: true,
        accelerometerX: 0.5,
        lightLevel: 500.0,
      );
      const sensorData2 = SensorData(
        isAccelerometerEnabled: true,
        isGyroscopeEnabled: false,
        isLightSensorEnabled: true,
        accelerometerX: 0.5,
        lightLevel: 500.0,
      );

      // Act & Assert
      expect(sensorData1, equals(sensorData2));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      const sensorData1 = SensorData(
        isAccelerometerEnabled: true,
        isGyroscopeEnabled: false,
        isLightSensorEnabled: true,
      );
      const sensorData2 = SensorData(
        isAccelerometerEnabled: false,
        isGyroscopeEnabled: false,
        isLightSensorEnabled: true,
      );

      // Act & Assert
      expect(sensorData1, isNot(equals(sensorData2)));
    });
  });
} 