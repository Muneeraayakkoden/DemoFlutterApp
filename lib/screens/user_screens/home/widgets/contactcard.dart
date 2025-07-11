import 'package:flutter/material.dart';
import 'action_cards.dart';

class Contactcard extends StatelessWidget {
  const Contactcard({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () => {},
      leadingIcon: Icons.person_search,
      title: 'All Users'
    );
  }
}