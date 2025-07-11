import 'package:flutter/material.dart';
import 'action_cards.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Meetingcard extends StatelessWidget {
  const Meetingcard({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () => {},
      leadingIcon: LucideIcons.calendarSearch,
      title: 'View All Meetings'
    );
  }
}