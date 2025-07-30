import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/sensor_bloc.dart';
import '../widgets/toggle_button.dart';
import '../widgets/loading_animation.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Controls'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<SensorBloc, SensorState>(
        builder: (context, state) {
          if (state is SensorLoading) {
            return const Center(
              child: LoadingAnimation(),
            );
          } else if (state is SensorLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sensor Controls',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ToggleButton(
                            title: 'Accelerometer',
                            isEnabled: state.sensorData.isAccelerometerEnabled,
                            onToggle: (enabled) {
                              context.read<SensorBloc>().add(
                                    ToggleSensorEvent(
                                      sensorType: 'accelerometer',
                                      enabled: enabled,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(height: 12),
                          ToggleButton(
                            title: 'Gyroscope',
                            isEnabled: state.sensorData.isGyroscopeEnabled,
                            onToggle: (enabled) {
                              context.read<SensorBloc>().add(
                                    ToggleSensorEvent(
                                      sensorType: 'gyroscope',
                                      enabled: enabled,
                                    ),
                                  );
                            },
                          ),
                          const SizedBox(height: 12),
                          ToggleButton(
                            title: 'Flashlight',
                            isEnabled: state.sensorData.isLightSensorEnabled,
                            onToggle: (enabled) {
                              context.read<SensorBloc>().add(
                                    ToggleSensorEvent(
                                      sensorType: 'flashlight',
                                      enabled: enabled,
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SensorBloc>().add(FetchSensorData());
                    },
                    child: const Text('Refresh Sensor Data'),
                  ),
                  const SizedBox(height: 20),
                  if (state.sensorData.accelerometerX != null ||
                      state.sensorData.gyroscopeX != null ||
                      state.sensorData.lightLevel != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sensor Readings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (state.sensorData.accelerometerX != null)
                              _buildSensorReading(
                                'Accelerometer',
                                'X: ${state.sensorData.accelerometerX!.toStringAsFixed(2)}\n'
                                'Y: ${state.sensorData.accelerometerY!.toStringAsFixed(2)}\n'
                                'Z: ${state.sensorData.accelerometerZ!.toStringAsFixed(2)}',
                              ),
                            if (state.sensorData.gyroscopeX != null)
                              _buildSensorReading(
                                'Gyroscope',
                                'X: ${state.sensorData.gyroscopeX!.toStringAsFixed(2)}\n'
                                'Y: ${state.sensorData.gyroscopeY!.toStringAsFixed(2)}\n'
                                'Z: ${state.sensorData.gyroscopeZ!.toStringAsFixed(2)}',
                              ),
                            if (state.sensorData.lightLevel != null)
                              _buildSensorReading(
                                'Light Level',
                                '${state.sensorData.lightLevel!.toStringAsFixed(2)} lux',
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else if (state is SensorError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getErrorMessage(state.message),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SensorBloc>().add(FetchSensorData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }

  Widget _buildSensorReading(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String message) {
    if (message.contains('Accelerometer is not available')) {
      return 'Accelerometer is not available on this device.\n\nThis sensor is required for motion detection and orientation changes.';
    } else if (message.contains('Gyroscope is not available')) {
      return 'Gyroscope is not available on this device.\n\nThis sensor is required for rotation detection and angular velocity measurements.';
    } else if (message.contains('Flashlight not available')) {
      return 'Flashlight is not available on this device.\n\nThis feature requires a camera with flash capability.';
    } else if (message.contains('Device error occurred')) {
      return 'A device error occurred.\n\nPlease try again or check if the required permissions are granted.';
    } else {
      return 'Error: $message\n\nPlease try again.';
    }
  }
} 