import 'package:flutter/material.dart';
import '../widgets/action_cards.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MeetingService extends StatelessWidget {
  const MeetingService({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () => {},
      leadingIcon: LucideIcons.calendarSearch,
      title: 'View All Meetings'
    );
  }
}