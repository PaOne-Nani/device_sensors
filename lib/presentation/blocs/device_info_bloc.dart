import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/device_info.dart';
import '../../domain/usecases/get_device_info.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

part 'device_info_event.dart';
part 'device_info_state.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  final GetDeviceInfo getDeviceInfo;

  DeviceInfoBloc({required this.getDeviceInfo}) : super(DeviceInfoInitial()) {
    on<FetchDeviceInfo>(_onFetchDeviceInfo);
  }

  Future<void> _onFetchDeviceInfo(
    FetchDeviceInfo event,
    Emitter<DeviceInfoState> emit,
  ) async {
    emit(DeviceInfoLoading());

    final result = await getDeviceInfo(const NoParams());

    result.fold(
      (failure) => emit(DeviceInfoError(_mapFailureToMessage(failure))),
      (deviceInfo) => emit(DeviceInfoLoaded(deviceInfo)),
    );
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
} 