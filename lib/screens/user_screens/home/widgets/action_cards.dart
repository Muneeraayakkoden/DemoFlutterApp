import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';

class ActionCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData leadingIcon;
  final String title;

  const ActionCard({
    super.key,
    required this.onTap,
    required this.leadingIcon,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: ColorClass.greenDarker,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(leadingIcon, color: ColorClass.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorClass.white,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: ColorClass.white, size: 20),
          ],
        ),
      ),
    );
  }
}
