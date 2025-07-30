import 'package:device_sensor/injection/injection_container.dart' as di;
import 'package:device_sensor/presentation/blocs/device_info_bloc.dart';
import 'package:device_sensor/presentation/blocs/sensor_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock SharedPreferences for testing
class MockSharedPreferences implements SharedPreferences {
  final Map<String, dynamic> _data = {};

  @override
  Future<bool> clear() async => true;

  @override
  Future<bool> commit() async => true;

  @override
  bool containsKey(String key) => _data.containsKey(key);

  @override
  dynamic get(String key) => _data[key];

  @override
  bool? getBool(String key) => _data[key] as bool?;

  @override
  double? getDouble(String key) => _data[key] as double?;

  @override
  int? getInt(String key) => _data[key] as int?;

  @override
  Set<String> getKeys() => _data.keys.toSet();

  @override
  String? getString(String key) => _data[key] as String?;

  @override
  List<String>? getStringList(String key) => _data[key] as List<String>?;

  @override
  Future<bool> reload() async => true;

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _data[key] = value;
    return true;
  }
}

void main() {
  group('Dependency Injection', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Register mock SharedPreferences
      GetIt.instance.registerSingleton<SharedPreferences>(MockSharedPreferences());
      
      await di.init();
    });

    tearDownAll(() {
      GetIt.instance.reset();
    });

    test('should register DeviceInfoBloc', () {
      // Act
      final bloc = di.sl<DeviceInfoBloc>();

      // Assert
      expect(bloc, isA<DeviceInfoBloc>());
    });

    test('should register SensorBloc', () {
      // Act
      final bloc = di.sl<SensorBloc>();

      // Assert
      expect(bloc, isA<SensorBloc>());
    });

    test('should create different instances of blocs', () {
      // Act
      final bloc1 = di.sl<DeviceInfoBloc>();
      final bloc2 = di.sl<DeviceInfoBloc>();

      // Assert
      expect(bloc1, isNot(same(bloc2)));
    });
  });
} 