import 'package:flutter/material.dart';

typedef StepBuilder = Widget Function(BuildContext context);

class ListingStepConfig {
  final String id;
  final String title;
  final StepBuilder builder;
  const ListingStepConfig({
    required this.id,
    required this.title,
    required this.builder,
  });
}

class ListingCreateProvider extends ChangeNotifier {
  final List<ListingStepConfig> steps;
  final VoidCallback? onStart;

  ListingCreateProvider({required this.steps, this.onStart})
    : assert(steps.isNotEmpty);

  // ✅ 폼(자유 확장)
  final Map<String, dynamic> form = {};
  void setField(String key, dynamic value) {
    form[key] = value;
    notifyListeners();
  }

  T? getField<T>(String key) => form[key] as T?;

  int _index = 0;
  int get index => _index;
  int get total => steps.length;
  ListingStepConfig get current => steps[_index];

  bool get isFirst => _index == 0;
  bool get isLast => _index == steps.length - 1;

  void start() {
    onStart?.call();
  }

  void next() {
    if (!isLast) {
      _index++;
      notifyListeners();
    }
  }

  void prev() {
    if (!isFirst) {
      _index--;
      notifyListeners();
    }
  }
}
