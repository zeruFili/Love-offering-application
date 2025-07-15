import 'package:flutter/material.dart';

class YouTubeStatusFilter extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;
  final Color Function(String) getStatusColor;

  const YouTubeStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatusChip('all', 'All', null),
            _buildStatusChip('available', 'Available', 'available'),
            _buildStatusChip('pending', 'Pending', 'pending'),
            _buildStatusChip('rejected', 'Rejected', 'rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, String label, String? statusForColor) {
    final isSelected = selectedStatus == status;
    final chipColor = statusForColor != null
        ? getStatusColor(statusForColor)
        : const Color(0xFF0A5D4A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (statusForColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : chipColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) => onStatusSelected(status),
        selectedColor: chipColor,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF2D3748),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
        side: BorderSide(
          color: isSelected ? chipColor : Colors.grey.shade300,
        ),
      ),
    );
  }
}
