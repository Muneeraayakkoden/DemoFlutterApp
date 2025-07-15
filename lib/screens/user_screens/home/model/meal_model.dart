class Meal {
  final String? id;
  final String? userId;
  final DateTime date;
  final bool breakfast;
  final bool lunch;
  final bool dinner;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Meal({
    this.id,
    this.userId,
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    this.createdAt,
    this.updatedAt,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      date: DateTime.parse(json['date']),
      breakfast: json['breakfast'] ?? false,
      lunch: json['lunch'] ?? false,
      dinner: json['dinner'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
    };
  }
}
