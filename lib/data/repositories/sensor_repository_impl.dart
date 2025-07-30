import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/sensor_data.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/local/sensor_local_datasource.dart';
import '../datasources/remote/sensor_remote_datasource.dart';


class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDataSource remoteDataSource;
  final SensorLocalDataSource localDataSource;

  SensorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, SensorData>> getSensorData() async {
    try {
      final sensorDataModel = await remoteDataSource.getSensorData();
      await localDataSource.cacheSensorData(sensorDataModel);
      return Right(sensorDataModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleAccelerometer(bool enabled) async {
    try {
      await remoteDataSource.toggleAccelerometer(enabled);
      return const Right(null);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleGyroscope(bool enabled) async {
    try {
      await remoteDataSource.toggleGyroscope(enabled);
      return const Right(null);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFlashlight(bool enabled) async {
    try {
      await remoteDataSource.toggleFlashlight(enabled);
      return const Right(null);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> startSensorStream() async {
    try {
      await remoteDataSource.startSensorStream();
      return const Right(null);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> stopSensorStream() async {
    try {
      await remoteDataSource.stopSensorStream();
      return const Right(null);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }
} 