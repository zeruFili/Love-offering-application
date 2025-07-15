import 'package:flutter/material.dart';
import '../Model/youtube_model.dart';

class YouTubeStatusDialog extends StatelessWidget {
  final YouTubeVideo video;
  final Color Function(String) getStatusColor;
  final Future<void> Function(YouTubeVideo, String) onUpdateVideoStatus;

  const YouTubeStatusDialog({
    super.key,
    required this.video,
    required this.getStatusColor,
    required this.onUpdateVideoStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Video Status',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusOption(
              'available', 'Available', video.status, video, context),
          _buildStatusOption(
              'pending', 'Pending', video.status, video, context),
          _buildStatusOption(
              'rejected', 'Rejected', video.status, video, context),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusOption(String value, String label, String currentStatus,
      YouTubeVideo video, BuildContext context) {
    final isSelected = currentStatus == value;
    final statusColor = getStatusColor(value);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? statusColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? statusColor.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? statusColor : const Color(0xFF2D3748),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: Radio<String>(
          value: value,
          groupValue: currentStatus,
          onChanged: (newValue) {
            if (newValue != null) {
              onUpdateVideoStatus(video, newValue);
              Navigator.pop(context);
            }
          },
          activeColor: statusColor,
        ),
      ),
    );
  }
}
