import 'package:flutter/material.dart';
import '../../../constants/color_class.dart';

//ItemList
class ItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const ItemCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? ColorClass.redBase : ColorClass.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? ColorClass.redBase : ColorClass.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
