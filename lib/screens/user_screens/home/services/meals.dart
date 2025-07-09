import 'package:flutter/material.dart';
import '../widgets/action_cards.dart';

class MealService extends StatelessWidget {
  const MealService({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () => {},
      leadingIcon: Icons.edit_calendar,
      title: 'Mark Your Meals'
    );
  }
}