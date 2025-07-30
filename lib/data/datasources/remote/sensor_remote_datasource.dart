import 'dart:async';
import 'package:flutter/services.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/sensor_data_model.dart';

abstract class SensorRemoteDataSource {
  Future<SensorDataModel> getSensorData();
  Future<void> toggleAccelerometer(bool enabled);
  Future<void> toggleGyroscope(bool enabled);
  Future<void> toggleFlashlight(bool enabled);
  Future<void> startSensorStream();
  Future<void> stopSensorStream();
}

class SensorRemoteDataSourceImpl implements SensorRemoteDataSource {
  static const MethodChannel _channel = MethodChannel('com.example.device_info/sensors');
  static const EventChannel _eventChannel = EventChannel('com.example.device_info/sensor_stream');
  
  bool _isAccelerometerEnabled = false;
  bool _isGyroscopeEnabled = false;
  bool _isFlashlightEnabled = false;
  
  double? _accelerometerX;
  double? _accelerometerY;
  double? _accelerometerZ;
  double? _gyroscopeX;
  double? _gyroscopeY;
  double? _gyroscopeZ;
  
  StreamSubscription? _sensorSubscription;

  @override
  Future<SensorDataModel> getSensorData() async {
    try {
      return SensorDataModel(
        isAccelerometerEnabled: _isAccelerometerEnabled,
        isGyroscopeEnabled: _isGyroscopeEnabled,
        isLightSensorEnabled: _isFlashlightEnabled,
        accelerometerX: _accelerometerX,
        accelerometerY: _accelerometerY,
        accelerometerZ: _accelerometerZ,
        gyroscopeX: _gyroscopeX,
        gyroscopeY: _gyroscopeY,
        gyroscopeZ: _gyroscopeZ,
        lightLevel: null, // Flashlight doesn't provide light level
      );
    } catch (e) {
      throw DeviceException('Failed to get sensor data: $e');
    }
  }

  @override
  Future<void> toggleAccelerometer(bool enabled) async {
    try {
      await _channel.invokeMethod('toggleAccelerometer', {'enabled': enabled});
      _isAccelerometerEnabled = enabled;
      if (enabled) {
        await startSensorStream();
      } else {
        _accelerometerX = null;
        _accelerometerY = null;
        _accelerometerZ = null;
        // Stop stream if no sensors are enabled
        if (!_isGyroscopeEnabled && !_isAccelerometerEnabled) {
          await stopSensorStream();
        }
      }
      print('Accelerometer toggled: enabled=$enabled, data: X=$_accelerometerX, Y=$_accelerometerY, Z=$_accelerometerZ');
    } on PlatformException catch (e) {
      if (e.code == 'UNAVAILABLE') {
        throw DeviceException('Accelerometer is not available on this device');
      } else {
        throw DeviceException('Failed to toggle accelerometer: ${e.message}');
      }
    } catch (e) {
      throw DeviceException('Failed to toggle accelerometer: $e');
    }
  }

  @override
  Future<void> toggleGyroscope(bool enabled) async {
    try {
      await _channel.invokeMethod('toggleGyroscope', {'enabled': enabled});
      _isGyroscopeEnabled = enabled;
      if (enabled) {
        await startSensorStream();
      } else {
        _gyroscopeX = null;
        _gyroscopeY = null;
        _gyroscopeZ = null;
        // Stop stream if no sensors are enabled
        if (!_isGyroscopeEnabled && !_isAccelerometerEnabled) {
          await stopSensorStream();
        }
      }
      print('Gyroscope toggled: enabled=$enabled, data: X=$_gyroscopeX, Y=$_gyroscopeY, Z=$_gyroscopeZ');
    } on PlatformException catch (e) {
      if (e.code == 'UNAVAILABLE') {
        throw DeviceException('Gyroscope is not available on this device');
      } else {
        throw DeviceException('Failed to toggle gyroscope: ${e.message}');
      }
    } catch (e) {
      throw DeviceException('Failed to toggle gyroscope: $e');
    }
  }

  @override
  Future<void> toggleFlashlight(bool enabled) async {
    try {
      await _channel.invokeMethod('toggleFlashlight', {'status': enabled});
      _isFlashlightEnabled = enabled;
    } catch (e) {
      throw DeviceException('Failed to toggle flashlight: $e');
    }
  }

  @override
  Future<void> startSensorStream() async {
    try {
      // Always cancel existing subscription before creating a new one
      await _sensorSubscription?.cancel();
      _sensorSubscription = null;
      
      _sensorSubscription = _eventChannel.receiveBroadcastStream().listen(
        (dynamic data) {
          try {
            if (data is Map) {
              final sensorType = data['sensorType'] as String?;
              final x = data['x'] as double?;
              final y = data['y'] as double?;
              final z = data['z'] as double?;
              
              print('Received sensor data: type=$sensorType, X=$x, Y=$y, Z=$z');
              print('Current state: gyroEnabled=$_isGyroscopeEnabled, accelEnabled=$_isAccelerometerEnabled');
              
              // Update sensor data based on sensor type
              if (sensorType == 'gyroscope' && _isGyroscopeEnabled) {
                _gyroscopeX = x;
                _gyroscopeY = y;
                _gyroscopeZ = z;
                print('Gyroscope data updated: X=$x, Y=$y, Z=$z');
              } else if (sensorType == 'accelerometer' && _isAccelerometerEnabled) {
                _accelerometerX = x;
                _accelerometerY = y;
                _accelerometerZ = z;
                print('Accelerometer data updated: X=$x, Y=$y, Z=$z');
              }
            }
          } catch (e) {
            // Log error but don't throw to prevent stream interruption
            print('Error processing sensor data: $e');
          }
        },
        onError: (error) {
          // Log error but don't throw to prevent stream interruption
          print('Sensor stream error: $error');
        },
      );
      print('Sensor stream started successfully');
    } catch (e) {
      throw DeviceException('Failed to start sensor stream: $e');
    }
  }

  @override
  Future<void> stopSensorStream() async {
    try {
      await _sensorSubscription?.cancel();
      _sensorSubscription = null;
    } catch (e) {
      throw DeviceException('Failed to stop sensor stream: $e');
    }
  }
} 