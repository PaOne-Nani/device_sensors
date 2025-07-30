import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function(bool) onToggle;

  const ToggleButton({
    super.key,
    required this.title,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
} 