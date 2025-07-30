import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/sensor_data.dart';
import '../../domain/usecases/get_sensor_data.dart';
import '../../domain/usecases/toggle_sensor.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

part 'sensor_event.dart';
part 'sensor_state.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  final GetSensorData getSensorData;
  final ToggleSensor toggleSensor;
  Timer? _refreshTimer;

  SensorBloc({
    required this.getSensorData,
    required this.toggleSensor,
  }) : super(SensorInitial()) {
    on<FetchSensorData>(_onFetchSensorData);
    on<ToggleSensorEvent>(_onToggleSensor);
  }

  Future<void> _onFetchSensorData(
    FetchSensorData event,
    Emitter<SensorState> emit,
  ) async {
    // Only emit loading if we don't have any sensor data yet
    if (state is! SensorLoaded) {
      emit(SensorLoading());
    }

    final result = await getSensorData(const NoParams());

    result.fold(
      (failure) => emit(SensorError(_mapFailureToMessage(failure))),
      (sensorData) {
        print('Sensor data fetched: accel=${sensorData.isAccelerometerEnabled}, gyro=${sensorData.isGyroscopeEnabled}');
        print('Accel data: X=${sensorData.accelerometerX}, Y=${sensorData.accelerometerY}, Z=${sensorData.accelerometerZ}');
        print('Gyro data: X=${sensorData.gyroscopeX}, Y=${sensorData.gyroscopeY}, Z=${sensorData.gyroscopeZ}');
        emit(SensorLoaded(sensorData));
      },
    );
  }

  Future<void> _onToggleSensor(
    ToggleSensorEvent event,
    Emitter<SensorState> emit,
  ) async {
    final result = await toggleSensor(ToggleSensorParams(
      sensorType: event.sensorType,
      enabled: event.enabled,
    ));

    result.fold(
      (failure) => emit(SensorError(_mapFailureToMessage(failure))),
      (_) {
        // Fetch sensor data immediately after toggle
        add(FetchSensorData());
        // Fetch again after a short delay to ensure sensor data is updated
        Future.delayed(const Duration(milliseconds: 200), () {
          add(FetchSensorData());
        });
        // Start periodic refresh if any sensor is enabled
        _startPeriodicRefresh();
      },
    );
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final currentState = state;
      if (currentState is SensorLoaded) {
        final hasEnabledSensors = currentState.sensorData.isAccelerometerEnabled || 
                                 currentState.sensorData.isGyroscopeEnabled;
        if (hasEnabledSensors) {
          add(FetchSensorData());
        } else {
          timer.cancel();
        }
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      case DeviceFailure:
        return 'Device error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
} 