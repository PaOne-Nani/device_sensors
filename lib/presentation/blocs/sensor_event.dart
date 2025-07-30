part of 'sensor_bloc.dart';

abstract class SensorEvent extends Equatable {
  const SensorEvent();

  @override
  List<Object> get props => [];
}

class FetchSensorData extends SensorEvent {}

class ToggleSensorEvent extends SensorEvent {
  final String sensorType;
  final bool enabled;

  const ToggleSensorEvent({
    required this.sensorType,
    required this.enabled,
  });

  @override
  List<Object> get props => [sensorType, enabled];
} 