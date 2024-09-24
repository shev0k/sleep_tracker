// lib/components/widgets/sleep_phase_card.dart

import 'package:flutter/material.dart';

class SleepPhaseCard extends StatelessWidget {
  final String title;
  final String hours;
  final IconData icon;
  final Color color;
  final String description;

  const SleepPhaseCard({
    super.key,
    required this.title,
    required this.hours,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return _buildSleepCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          collapsedIconColor: Colors.white.withOpacity(0.7),
          iconColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 30),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Text(
                hours,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
              ),
            ],
          ),
          children: [
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
        child: child,
      ),
    );
  }
}
