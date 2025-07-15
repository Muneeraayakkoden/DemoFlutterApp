import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/markmeal_provider.dart';
import '../../../../constants/color_class.dart';
import '../../../../constants/textstyle_class.dart';

class MonthCalendar extends StatefulWidget {
  const MonthCalendar({super.key});

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
  }

  void _goToPrevMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  List<DateTime> _getMonthDays(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    return [
      for (int i = 0; i < last.day; i++)
        DateTime(month.year, month.month, i + 1),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkMealProvider>(
      builder: (context, provider, _) {
        final dates = _getMonthDays(_displayedMonth);
        final monthLabel = DateFormat('MMMM yyyy').format(_displayedMonth);
        final today = provider.today;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: _goToPrevMonth,
                  ),
                  Text(
                    monthLabel,
                    style: TextStyleClass.primaryFont700(16, ColorClass.black),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    onPressed: _goToNextMonth,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _MonthGrid(
                dates: dates,
                provider: provider,
                today: today,
                displayedMonth: _displayedMonth,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final List<DateTime> dates;
  final MarkMealProvider provider;
  final DateTime today;
  final DateTime displayedMonth;
  const _MonthGrid({
    required this.dates,
    required this.provider,
    required this.today,
    required this.displayedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = dates.first;
    final startWeekday =
        firstDay.weekday % 7; // Sunday=0, Monday=1, ..., Saturday=6
    final totalCells = dates.length + startWeekday;
    const weekdayInitials = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (i) {
            return Expanded(
              child: Center(
                child: Text(
                  weekdayInitials[i],
                  style: TextStyleClass.primaryFont600(
                    13,
                    i == 0 ? ColorClass.redBase : ColorClass.black,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: totalCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox.shrink();
              final date = dates[index - startWeekday];
              final isToday = provider.normalizeDate(date) == today;
              return _DayCell(date: date, provider: provider, isToday: isToday);
            },
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final MarkMealProvider provider;
  final bool isToday;
  const _DayCell({
    required this.date,
    required this.provider,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final allLocked = MealType.values.every(
      (m) => !provider.isMarkingAllowed(date, m),
    );
    return GestureDetector(
      onTap: () {
        if (allLocked) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text("Meal Marking Expired"),
                  content: const Text("You can't mark meals for this date."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
          );
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => _MealModal(date: date, provider: provider),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isToday ? ColorClass.brandLightGreen : ColorClass.white,
          border: Border.all(
            color: isToday ? ColorClass.brandLightGreen : ColorClass.neutral300,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyleClass.primaryFont700(
                      14,
                      date.weekday == DateTime.sunday
                          ? ColorClass.redBase
                          : ColorClass.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        MealType.values.map((mealType) {
                          return _MealCheckbox(
                            date: date,
                            meal: mealType,
                            label: mealType.name[0].toUpperCase(),
                            provider: provider,
                            size: 13, // smaller size
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            if (allLocked)
              const Positioned(
                top: 2,
                right: 2,
                child: Icon(
                  Icons.lock,
                  size: 12,
                  color: ColorClass.textSoft400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MealCheckbox extends StatelessWidget {
  final DateTime date;
  final MealType meal;
  final String label;
  final MarkMealProvider provider;
  final double size;
  const _MealCheckbox({
    required this.date,
    required this.meal,
    required this.label,
    required this.provider,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    final checked = provider.isMealMarked(date, meal);
    final expired = !provider.isMarkingAllowed(date, meal);
    return GestureDetector(
      onTap:
          expired
              ? () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Meal Marking expired'),
                        content: const Text(
                          "You can't mark meal for past time.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'OK',
                              style: TextStyle(color: ColorClass.black),
                            ),
                          ),
                        ],
                      ),
                );
              }
              : () async => await provider.toggleMeal(
                date,
                meal,
                onError: (msg) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: checked ? ColorClass.brandLightGreen : ColorClass.white,
          border: Border.all(
            color:
                expired
                    ? ColorClass.textSoft400
                    : (checked ? ColorClass.brandLightGreen : ColorClass.black),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child:
              checked
                  ? Icon(Icons.check, size: size - 3)
                  : expired
                  ? Icon(
                    Icons.lock,
                    size: size - 2,
                    color: ColorClass.textSoft400,
                  )
                  : Text(
                    label,
                    style: TextStyleClass.primaryFont600(
                      size - 2,
                      ColorClass.black,
                    ),
                  ),
        ),
      ),
    );
  }
}

class _MealModal extends StatefulWidget {
  final DateTime date;
  final MarkMealProvider provider;
  const _MealModal({required this.date, required this.provider});

  @override
  State<_MealModal> createState() => _MealModalState();
}

class _MealModalState extends State<_MealModal> {
  late Map<MealType, bool> _checked;

  @override
  void initState() {
    super.initState();
    final meal = widget.provider.getMealForDate(widget.date);
    _checked = {
      MealType.breakfast: meal.breakfast,
      MealType.lunch: meal.lunch,
      MealType.dinner: meal.dinner,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(widget.date),
            style: TextStyleClass.primaryFont700(16, ColorClass.black),
          ),
          const SizedBox(height: 16),
          ...MealType.values.map((meal) {
            final expired =
                !widget.provider.isMarkingAllowed(widget.date, meal);
            return CheckboxListTile(
              value: _checked[meal],
              onChanged:
                  expired
                      ? null
                      : (val) => setState(() => _checked[meal] = val ?? false),
              title: Text(meal.name[0].toUpperCase() + meal.name.substring(1)),
              secondary:
                  expired
                      ? Icon(Icons.lock, color: ColorClass.textSoft400)
                      : null,
            );
          }),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                  for (final meal in MealType.values) {
                    final currentMarked = widget.provider.isMealMarked(
                      widget.date,
                      meal,
                    );
                    if (_checked[meal] != currentMarked &&
                        widget.provider.isMarkingAllowed(widget.date, meal)) {
                      await widget.provider.toggleMeal(widget.date, meal);
                    }
                  }
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorClass.brandLightGreen,
                  foregroundColor: ColorClass.black,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
