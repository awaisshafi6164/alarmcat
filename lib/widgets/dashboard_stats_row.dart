import 'package:flutter/material.dart';

class DashboardStatsRow extends StatelessWidget {
  final String title1;
  final String value1;
  final String title2;
  final String value2;

  const DashboardStatsRow({
    super.key,
    required this.title1,
    required this.value1,
    required this.title2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: title1,
            value: value1,
            icon: Icons.alarm,
            startColor: const Color(0xFF6A1B9A), // Deep Purple 800
            endColor: const Color(0xFFAB47BC), // Purple 400
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            title: title2,
            value: value2,
            icon: Icons.category,
            startColor: const Color(0xFF1565C0), // Blue 800
            endColor: const Color(0xFF42A5F5), // Blue 400
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color startColor,
    required Color endColor,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative icon
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.15)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon and Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Value
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
