import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/device_info.dart';
import '../repositories/device_info_repository.dart';

class GetDeviceInfo implements UseCase<DeviceInfo, NoParams> {
  final DeviceInfoRepository repository;

  GetDeviceInfo(this.repository);

  @override
  Future<Either<Failure, DeviceInfo>> call(NoParams params) async {
    return await repository.getDeviceInfo();
  }
} 