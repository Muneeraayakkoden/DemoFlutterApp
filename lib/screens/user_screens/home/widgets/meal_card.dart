import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';

class MealCard extends StatelessWidget {
  const MealCard({super.key});
  @override
  Widget build(BuildContext context) {
    final mealCounts = {
      'breakfast': 0,
      'lunch': 0,
      'dinner': 0,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Month\'s Meal Count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorClass.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMealCountItem('Breakfast', mealCounts['breakfast'] ?? 0,
                  Icons.free_breakfast, Colors.amber),
              _buildMealCountItem('Lunch', mealCounts['lunch'] ?? 0,
                  Icons.lunch_dining, Colors.orange),
              _buildMealCountItem('Dinner', mealCounts['dinner'] ?? 0,
                  Icons.dinner_dining, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealCountItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
