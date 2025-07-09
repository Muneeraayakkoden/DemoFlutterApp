import 'package:flutter/material.dart';
import '../widgets/action_cards.dart';

class ContactService extends StatelessWidget {
  const ContactService({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () => {},
      leadingIcon: Icons.person_search,
      title: 'All Users'
    );
  }
}