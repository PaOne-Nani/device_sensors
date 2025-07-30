part of 'device_info_bloc.dart';

abstract class DeviceInfoState extends Equatable {
  const DeviceInfoState();

  @override
  List<Object> get props => [];
}

class DeviceInfoInitial extends DeviceInfoState {}

class DeviceInfoLoading extends DeviceInfoState {}

class DeviceInfoLoaded extends DeviceInfoState {
  final DeviceInfo deviceInfo;

  const DeviceInfoLoaded(this.deviceInfo);

  @override
  List<Object> get props => [deviceInfo];
}

class DeviceInfoError extends DeviceInfoState {
  final String message;

  const DeviceInfoError(this.message);

  @override
  List<Object> get props => [message];
} 