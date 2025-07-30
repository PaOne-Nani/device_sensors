import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/device_info.dart';
import '../../domain/repositories/device_info_repository.dart';
import '../datasources/local/device_info_local_datasource.dart';
import '../datasources/remote/device_info_remote_datasource.dart';


class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final DeviceInfoRemoteDataSource remoteDataSource;
  final DeviceInfoLocalDataSource localDataSource;

  DeviceInfoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, DeviceInfo>> getDeviceInfo() async {
    try {
      final deviceInfoModel = await remoteDataSource.getDeviceInfo();
      await localDataSource.cacheDeviceInfo(deviceInfoModel);
      return Right(deviceInfoModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getDeviceName() async {
    try {
      final deviceName = await remoteDataSource.getDeviceName();
      return Right(deviceName);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getOSVersion() async {
    try {
      final osVersion = await remoteDataSource.getOSVersion();
      return Right(osVersion);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getBatteryLevel() async {
    try {
      final batteryLevel = await remoteDataSource.getBatteryLevel();
      return Right(batteryLevel);
    } on DeviceException catch (e) {
      return Left(DeviceFailure(e.message));
    }
  }
} 