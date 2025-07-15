import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../constants/api_urls.dart';
import '../model/meal_model.dart';
import '../../../../utils/shared_utils.dart';
import 'dart:developer' as developer;

class MealService {
  Future<List<Meal>> fetchUserMeals() async {
    try {
      final token = await SharedUtils.getString('auth_token');
      final response = await http.get(
        Uri.parse(ApiUrls.getMealsForUser()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      developer.log(
        'GET /meals/my-meals response: ${response.statusCode} ${response.body}',
        name: 'MealService',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Meal.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch meals');
      }
    } catch (e) {
      developer.log('Error fetching meals: $e', name: 'MealService', error: e);
      rethrow;
    }
  }

  Future<Meal> markMeal(Meal meal) async {
    try {
      final token = await SharedUtils.getString('auth_token');
      final response = await http.post(
        Uri.parse(ApiUrls.addMealForUser()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(meal.toJson()),
      );
      developer.log(
        'POST /meals/mark request: ${meal.toJson()}',
        name: 'MealService',
      );
      developer.log(
        'POST /meals/mark response: ${response.statusCode} ${response.body}',
        name: 'MealService',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Meal.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to mark meal');
      }
    } catch (e) {
      developer.log('Error marking meal: $e', name: 'MealService', error: e);
      rethrow;
    }
  }
}
