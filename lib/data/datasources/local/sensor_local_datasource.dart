import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/sensor_data_model.dart';

abstract class SensorLocalDataSource {
  Future<SensorDataModel> getLastSensorData();
  Future<void> cacheSensorData(SensorDataModel sensorData);
}

class SensorLocalDataSourceImpl implements SensorLocalDataSource {
  final SharedPreferences sharedPreferences;

  SensorLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<SensorDataModel> getLastSensorData() async {
    try {
      final jsonString = sharedPreferences.getString('sensor_data');
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return SensorDataModel.fromJson(jsonMap);
      } else {
        throw CacheException('No cached sensor data found');
      }
    } catch (e) {
      throw CacheException('Failed to get cached sensor data: $e');
    }
  }

  @override
  Future<void> cacheSensorData(SensorDataModel sensorData) async {
    try {
      final jsonString = json.encode(sensorData.toJson());
      await sharedPreferences.setString('sensor_data', jsonString);
    } catch (e) {
      throw CacheException('Failed to cache sensor data: $e');
    }
  }
} 