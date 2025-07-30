import 'package:flutter/material.dart';
import '../../domain/entities/device_info.dart';

class DeviceInfoCard extends StatelessWidget {
  final DeviceInfo deviceInfo;

  const DeviceInfoCard({
    super.key,
    required this.deviceInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.phone_android,
                  size: 32,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    deviceInfo.deviceName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.info_outline,
              'OS Version',
              deviceInfo.osVersion,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.battery_full,
              'Battery Level',
              '${deviceInfo.batteryLevel}%',
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: deviceInfo.batteryLevel / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                deviceInfo.batteryLevel > 20 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
} 