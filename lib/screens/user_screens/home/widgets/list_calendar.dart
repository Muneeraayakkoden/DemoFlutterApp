import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../constants/color_class.dart';
import '../provider/markmeal_provider.dart';

class ListCalender extends StatefulWidget {
  const ListCalender({super.key});

  @override
  State<ListCalender> createState() => _ListCalenderState();
}

class _ListCalenderState extends State<ListCalender> {
  late ScrollController _scrollController;
  int? todayIndex;
  bool _scrolledToToday = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MarkMealProvider>(context, listen: false);
      final idx = provider.getTodayIndex();
      setState(() {
        todayIndex = idx;
      });
      if (idx != -1 && !_scrolledToToday) {
        _scrollToToday(idx);
        _scrolledToToday = true;
      }
    });
  }

  void _scrollToToday(int idx) {
    _scrollController.animateTo(
      idx * 72.0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkMealProvider>(
      builder: (context, provider, _) {
        final dates = provider.getThreeMonthDates();
        final today = provider.today;
        // Preprocess: build a list of items with month headers
        final List<_CalendarListItemOrHeader> calendarItems = [];
        String? lastMonth;
        for (final date in dates) {
          final month = DateFormat('MMMM yyyy').format(date);
          if (lastMonth != month) {
            calendarItems.add(_CalendarListItemOrHeader.header(month));
            lastMonth = month;
          }
          calendarItems.add(_CalendarListItemOrHeader.date(date));
        }
        return Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              itemCount: calendarItems.length,
              itemBuilder: (context, idx) {
                final item = calendarItems[idx];
                if (item.isHeader) {
                  return _buildMonthHeader(item.header!);
                } else {
                  final date = item.date!;
                  final isToday = provider.normalizeDate(date) == today;
                  return _CalendarListItem(date: date, isToday: isToday);
                }
              },
            ),
            Positioned(
              bottom: 20,
              right: 30,
              child: FloatingActionButton(
                backgroundColor: ColorClass.brandLightGreen,
                onPressed: () {
                  final idx = provider.getTodayIndex();
                  if (idx != -1) {
                    // Find the index in calendarItems for today
                    int calendarIdx = calendarItems.indexWhere(
                      (item) =>
                          !item.isHeader &&
                          provider.normalizeDate(item.date!) == today,
                    );
                    if (calendarIdx != -1) {
                      _scrollToToday(calendarIdx);
                    }
                  }
                },
                child: const Text(
                  'Today',
                  style: TextStyle(color: ColorClass.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMonthHeader(String month) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: ColorClass.brandLightGreen,
      child: Text(
        month,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: ColorClass.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _CalendarListItem extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  const _CalendarListItem({required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 65,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration:
                      isToday
                          ? BoxDecoration(
                            color: ColorClass.brandLightGreen,
                            borderRadius: BorderRadius.circular(6),
                          )
                          : null,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: ColorClass.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE').format(date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorClass.neutral500,
                  ),
                ),
              ],
            ),
          ),
          // Checkboxes
          const SizedBox(width: 32),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MealCheckbox(date: date, meal: MealType.breakfast, label: 'B'),
                _MealCheckbox(date: date, meal: MealType.lunch, label: 'L'),
                _MealCheckbox(date: date, meal: MealType.dinner, label: 'D'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCheckbox extends StatelessWidget {
  final DateTime date;
  final MealType meal;
  final String label;
  const _MealCheckbox({
    required this.date,
    required this.meal,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkMealProvider>(
      builder: (context, provider, _) {
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
                                child: const Text('OK', style: TextStyle(color: ColorClass.black)),
                              ),
                            ],
                          ),
                    );
                  }
                  : () => provider.toggleMeal(
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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: checked ? ColorClass.brandLightGreen : ColorClass.white,
              border: Border.all(
                color:
                    expired
                        ? ColorClass.textSoft400
                        : (checked
                            ? ColorClass.brandLightGreen
                            : ColorClass.black),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child:
                  checked
                      ? const Icon(Icons.check, size: 22)
                      : expired
                      ? const Icon(
                        Icons.lock,
                        size: 20,
                        color: ColorClass.textSoft400,
                      )
                      : Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorClass.black,
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }
}

// Helper class to represent either a header or a date item
class _CalendarListItemOrHeader {
  final String? header;
  final DateTime? date;
  final bool isHeader;
  _CalendarListItemOrHeader.header(this.header) : date = null, isHeader = true;
  _CalendarListItemOrHeader.date(this.date) : header = null, isHeader = false;
}
