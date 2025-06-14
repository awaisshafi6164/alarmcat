import 'package:flutter/material.dart';

class AlarmCard extends StatefulWidget {
  final String label;
  final String time;
  final String repeatDays;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final String ringtone;
  final bool vibration;
  final bool oneTime;
  final bool preAlarm;
  final String snooze;
  final String note;

  const AlarmCard({
    super.key,
    required this.label,
    required this.time,
    required this.repeatDays,
    required this.enabled,
    required this.onToggle,
    required this.ringtone,
    required this.vibration,
    required this.oneTime,
    required this.preAlarm,
    required this.snooze,
    required this.note,
  });

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  bool expanded = false;

  String getDisplayRepeatDays() {
    final days = widget.repeatDays
        .split(',')
        .map((d) => d.trim())
        .where((d) => d.isNotEmpty)
        .toList();
    const weekdays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};
    const weekend = {'Sat', 'Sun'};
    if (days.length == 7) return 'Everyday';
    if (days.toSet().containsAll(weekdays) && days.length == 5)
      return 'Weekdays';
    if (days.toSet().containsAll(weekend) && days.length == 2) return 'Weekend';
    return days.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF232533),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags row at the top of main card
                if (widget.vibration || widget.oneTime || widget.preAlarm)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (widget.vibration)
                        _buildTag(
                          'Vibration',
                          Colors.green.shade100,
                          Colors.green.shade700,
                          Icons.vibration,
                        ),
                      if (widget.oneTime)
                        _buildTag(
                          'One-time',
                          Colors.orange.shade100,
                          Colors.orange.shade700,
                          Icons.alarm_add,
                        ),
                      if (widget.preAlarm)
                        _buildTag(
                          'Pre-Alarm',
                          Colors.purple.shade100,
                          Colors.purple.shade700,
                          Icons.notifications_active,
                        ),
                    ],
                  ),
                if (widget.vibration || widget.oneTime || widget.preAlarm)
                  const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.label,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.time,
                                style: const TextStyle(
                                  fontSize: 54,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getDisplayRepeatDays(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Wrap Switch with IgnorePointer to prevent toggling when clicking the card
                        IgnorePointer(
                          child: Switch(
                            value: widget.enabled,
                            onChanged: widget.onToggle,
                            activeColor: Colors.blue.shade700,
                          ),
                        ),
                        // Keep the arrow icon for visual indication
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Colors.white.withOpacity(0.5),
                          size: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF232533),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(Icons.music_note, 'Ringtone', widget.ringtone),
                _buildDetailItem(Icons.snooze, 'Snooze', widget.snooze),
                if (widget.note.isNotEmpty)
                  _buildDetailItem(Icons.note, 'Note', widget.note),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(
    String label,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
