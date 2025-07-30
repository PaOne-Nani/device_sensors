import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/sensor_data.dart';
import '../repositories/sensor_repository.dart';

class GetSensorData implements UseCase<SensorData, NoParams> {
  final SensorRepository repository;

  GetSensorData(this.repository);

  @override
  Future<Either<Failure, SensorData>> call(NoParams params) async {
    return await repository.getSensorData();
  }
} 