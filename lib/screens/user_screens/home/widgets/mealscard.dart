import 'package:flutter/material.dart';
import 'action_cards.dart';

class Mealscard extends StatelessWidget {
  const Mealscard({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () => {},
      leadingIcon: Icons.edit_calendar,
      title: 'Mark Your Meals'
    );
  }
}