class UserPreferenceModel {
  final List<String> preferCategories;

  UserPreferenceModel({required this.preferCategories});

  factory UserPreferenceModel.fromJson(Map<String, dynamic> json) {
    List<String> categories = List<String>.from(json['preferCategories'] ?? []);
    return UserPreferenceModel(preferCategories: categories);
  }

  Map<String, dynamic> toJson() {
    return {
      'preferCategories': preferCategories,
    };
  }
}
