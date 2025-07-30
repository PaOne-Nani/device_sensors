import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/local/device_info_local_datasource.dart';
import '../data/datasources/local/sensor_local_datasource.dart';
import '../data/datasources/remote/device_info_remote_datasource.dart';
import '../data/datasources/remote/sensor_remote_datasource.dart';
import '../data/repositories/device_info_repository_impl.dart';
import '../data/repositories/sensor_repository_impl.dart';
import '../domain/repositories/device_info_repository.dart';
import '../domain/repositories/sensor_repository.dart';
import '../domain/usecases/get_device_info.dart';
import '../domain/usecases/get_sensor_data.dart';
import '../domain/usecases/toggle_sensor.dart';
import '../presentation/blocs/device_info_bloc.dart';
import '../presentation/blocs/sensor_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
    () => DeviceInfoBloc(getDeviceInfo: sl()),
  );
  sl.registerFactory(
    () => SensorBloc(
      getSensorData: sl(),
      toggleSensor: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDeviceInfo(sl()));
  sl.registerLazySingleton(() => GetSensorData(sl()));
  sl.registerLazySingleton(() => ToggleSensor(sl()));

  // Repository
  sl.registerLazySingleton<DeviceInfoRepository>(
    () => DeviceInfoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<SensorRepository>(
    () => SensorRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<DeviceInfoRemoteDataSource>(
    () => DeviceInfoRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<DeviceInfoLocalDataSource>(
    () => DeviceInfoLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SensorRemoteDataSource>(
    () => SensorRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SensorLocalDataSource>(
    () => SensorLocalDataSourceImpl(sl()),
  );

  // External
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }
} 