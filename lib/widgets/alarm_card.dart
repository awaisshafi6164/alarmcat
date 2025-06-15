import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

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
    this.onEdit,
    this.onDelete,
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
          onTap: () => setState(() => expanded = !expanded),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF232533),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags row at the top
                if (widget.vibration || widget.oneTime || widget.preAlarm)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (widget.vibration)
                        _buildTag(
                          'VIBRATION',
                          Colors.green.shade100,
                          Colors.green.shade700,
                          Icons.vibration,
                        ),
                      if (widget.oneTime)
                        _buildTag(
                          'ONE-TIME',
                          Colors.orange.shade100,
                          Colors.orange.shade700,
                          Icons.alarm_add,
                        ),
                      if (widget.preAlarm)
                        _buildTag(
                          'PRE-ALARM',
                          Colors.purple.shade100,
                          Colors.purple.shade700,
                          Icons.notifications_active,
                        ),
                    ],
                  ),
                if (widget.vibration || widget.oneTime || widget.preAlarm)
                  const SizedBox(height: 12),

                // Main content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time and label column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label row
                          Text(
                            widget.label.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Time display
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.time,
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Repeat days and edit/delete buttons
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  getDisplayRepeatDays(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Toggle switch and edit/delete buttons below it
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Switch(
                              value: widget.enabled,
                              onChanged: widget.onToggle,
                              activeColor: Colors.blueAccent,
                              activeTrackColor: Colors.blueAccent.withOpacity(
                                0.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildIconButton(
                                icon: Icons.edit_rounded,
                                color: Colors.blueGrey.shade300,
                                onPressed: widget.onEdit,
                              ),
                              const SizedBox(width: 8),
                              _buildIconButton(
                                icon: Icons.delete_rounded,
                                color: Colors.red.shade400,
                                onPressed: widget.onDelete,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Expanded content
        if (expanded) _buildExpandedContent(),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3142),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(
            Icons.music_note_rounded,
            'Ringtone',
            widget.ringtone,
          ),
          _buildDetailItem(Icons.snooze_rounded, 'Snooze', widget.snooze),
          if (widget.note.isNotEmpty)
            _buildDetailItem(Icons.note_alt_rounded, 'Note', widget.note),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
                  title.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
