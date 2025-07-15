import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/meal_model.dart';
import '../services/meal_service.dart';
import 'dart:developer' as developer;

/// Enum for meal types
enum MealType { breakfast, lunch, dinner }

/// Provider for managing marked meals, fetching from and syncing to backend.
class MarkMealProvider extends ChangeNotifier {
  final Map<DateTime, Meal> _meals = {};
  final MealService _mealService = MealService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  MarkMealProvider() {
    fetchMarkedMeals();
  }

  /// Fetch all marked meals from backend and populate state.
  Future<void> fetchMarkedMeals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final meals = await _mealService.fetchUserMeals();
      _meals.clear();
      for (final meal in meals) {
        _meals[normalizeDate(meal.date)] = meal;
      }
      developer.log(
        'Fetched marked meals from backend',
        name: 'MarkMealProvider',
      );
    } catch (e) {
      _error = 'Failed to fetch meals';
      developer.log(
        'Error fetching meals: $e',
        name: 'MarkMealProvider',
        error: e,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get the Meal object for a date, or a default if not present.
  Meal getMealForDate(DateTime date) {
    final day = normalizeDate(date);
    return _meals[day] ??
        Meal(date: day, breakfast: false, lunch: false, dinner: false);
  }

  /// Check if a meal is marked for a date.
  bool isMealMarked(DateTime date, MealType meal) {
    final m = getMealForDate(date);
    switch (meal) {
      case MealType.breakfast:
        return m.breakfast;
      case MealType.lunch:
        return m.lunch;
      case MealType.dinner:
        return m.dinner;
    }
  }

  /// Check if marking is allowed for a given meal and date.
  bool isMarkingAllowed(DateTime date, MealType meal) {
    final now = DateTime.now();
    final normalizedDate = normalizeDate(date);
    final todayDate = today;
    if (normalizedDate.isBefore(todayDate)) return false;
    if (normalizedDate == todayDate) {
      if (meal == MealType.breakfast || meal == MealType.lunch) {
        return now.hour < 6;
      } else if (meal == MealType.dinner) {
        return now.hour < 14;
      }
    }
    return true;
  }

  /// Toggle a meal for a date, sync to backend, and update state.
  Future<void> toggleMeal(
    DateTime date,
    MealType meal, {
    Function(String)? onError,
  }) async {
    final day = normalizeDate(date);
    final current = getMealForDate(day);
    bool newBreakfast = current.breakfast;
    bool newLunch = current.lunch;
    bool newDinner = current.dinner;
    switch (meal) {
      case MealType.breakfast:
        newBreakfast = !current.breakfast;
        break;
      case MealType.lunch:
        newLunch = !current.lunch;
        break;
      case MealType.dinner:
        newDinner = !current.dinner;
        break;
    }
    // Check marking allowed
    if (!isMarkingAllowed(day, meal)) {
      if (onError != null) onError('Marking time has expired');
      return;
    }
    final mealModel = Meal(
      date: day,
      breakfast: newBreakfast,
      lunch: newLunch,
      dinner: newDinner,
    );
    try {
      _isLoading = true;
      notifyListeners();
      final result = await _mealService.markMeal(mealModel);
      _meals[day] = result;
      developer.log(
        'Marked meal updated for $day: $result',
        name: 'MarkMealProvider',
      );
    } catch (e) {
      if (onError != null) onError('Failed to update meal: $e');
      developer.log(
        'Error marking meal: $e',
        name: 'MarkMealProvider',
        error: e,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get a list of DateTime for three months (prev, current, next)
  List<DateTime> getThreeMonthDates() {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month - 1, 1);
    final last = DateTime(now.year, now.month + 2, 0);
    List<DateTime> days = [];
    for (
      DateTime d = first;
      d.isBefore(last) || d.isAtSameMomentAs(last);
      d = d.add(const Duration(days: 1))
    ) {
      days.add(d);
    }
    return days;
  }

  /// Group dates by month for UI
  Map<String, List<DateTime>> getDatesGroupedByMonth() {
    final dates = getThreeMonthDates();
    final Map<String, List<DateTime>> grouped = {};
    for (final d in dates) {
      final key = DateFormat('yyyy-MM').format(d);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(d);
    }
    return grouped;
  }

  /// Helper to normalize date (remove time part)
  DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Get normalized today
  DateTime get today => normalizeDate(DateTime.now());

  /// Get index of today in the three-month date list
  int getTodayIndex() {
    final dates = getThreeMonthDates();
    final todayDate = today;
    for (int i = 0; i < dates.length; i++) {
      if (normalizeDate(dates[i]) == todayDate) {
        return i;
      }
    }
    return -1;
  }
}
