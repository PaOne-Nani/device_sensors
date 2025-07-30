import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/sensor_repository.dart';

class ToggleSensorParams {
  final String sensorType;
  final bool enabled;

  ToggleSensorParams({required this.sensorType, required this.enabled});
}

class ToggleSensor implements UseCase<void, ToggleSensorParams> {
  final SensorRepository repository;

  ToggleSensor(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleSensorParams params) async {
    switch (params.sensorType) {
      case 'accelerometer':
        return await repository.toggleAccelerometer(params.enabled);
      case 'gyroscope':
        return await repository.toggleGyroscope(params.enabled);
      case 'flashlight':
        return await repository.toggleFlashlight(params.enabled);
      default:
        return const Left(DeviceFailure('Unknown sensor type'));
    }
  }
} 