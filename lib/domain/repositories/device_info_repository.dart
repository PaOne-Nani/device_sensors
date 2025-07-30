import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/device_info.dart';

abstract class DeviceInfoRepository {
  Future<Either<Failure, DeviceInfo>> getDeviceInfo();
  Future<Either<Failure, String>> getDeviceName();
  Future<Either<Failure, String>> getOSVersion();
  Future<Either<Failure, int>> getBatteryLevel();
} 