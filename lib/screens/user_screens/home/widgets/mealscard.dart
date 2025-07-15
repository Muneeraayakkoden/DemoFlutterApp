import 'package:flutter/material.dart';
import 'action_cards.dart';
import '../../../../constants/color_class.dart';
import 'list_calendar.dart';
import 'month_calendar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Mealscard extends StatelessWidget {
  const Mealscard({super.key});

  void _showMarkMealsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const MarkMealsModalContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      onTap: () => _showMarkMealsModal(context),
      leadingIcon: Icons.edit_calendar,
      title: 'Mark Your Meals',
    );
  }
}

class MarkMealsModalContent extends StatelessWidget {
  const MarkMealsModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 16, left: 0, right: 0, bottom: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  Text(
                    'Mark Your Meals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorClass.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const TabBar(
                tabs: [
                  Tab(icon: Icon(LucideIcons.list), text: 'List'),
                  Tab(icon: Icon(LucideIcons.calendarDays), text: 'Calendar'),
                ],
                labelColor: ColorClass.black,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(),
                dividerColor: Colors.transparent,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(
                  children: [const ListCalender(), MonthCalendar()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
