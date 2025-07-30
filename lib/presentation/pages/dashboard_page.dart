import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/device_info_bloc.dart';
import '../widgets/device_info_card.dart';
import '../widgets/loading_animation.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
        builder: (context, state) {
          if (state is DeviceInfoLoading) {
            return const Center(
              child: LoadingAnimation(),
            );
          } else if (state is DeviceInfoLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DeviceInfoCard(deviceInfo: state.deviceInfo),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DeviceInfoBloc>().add(FetchDeviceInfo());
                    },
                    child: const Text('Refresh Device Info'),
                  ),
                ],
              ),
            );
          } else if (state is DeviceInfoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DeviceInfoBloc>().add(FetchDeviceInfo());
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
} 