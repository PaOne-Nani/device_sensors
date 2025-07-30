import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/sensor_data.dart';

abstract class SensorRepository {
  Future<Either<Failure, SensorData>> getSensorData();
  Future<Either<Failure, void>> toggleAccelerometer(bool enabled);
  Future<Either<Failure, void>> toggleGyroscope(bool enabled);
  Future<Either<Failure, void>> toggleFlashlight(bool enabled);
  Future<Either<Failure, void>> startSensorStream();
  Future<Either<Failure, void>> stopSensorStream();
} 