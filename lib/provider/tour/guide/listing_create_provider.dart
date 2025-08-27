import 'package:flutter/material.dart';

typedef StepBuilder = Widget Function(BuildContext context);
typedef NextGuard = Future<bool> Function();

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

  final Map<String, dynamic> form = {};
  void setField(String key, dynamic value) {
    form[key] = value;
    notifyListeners();
  }

  void setFields(Map<String, dynamic> kv) {
    form.addAll(kv);
    notifyListeners();
  }

  T? getField<T>(String key) => form[key] as T?;
  void removeField(String key) {
    form.remove(key);
    notifyListeners();
  }

  int _index = 0;
  int get index => _index;
  int get total => steps.length;
  ListingStepConfig get current => steps[_index];
  String get currentId => current.id;

  bool get isFirst => _index == 0;
  bool get isLast => _index == steps.length - 1;

  final Map<String, NextGuard> _nextGuards = {};
  void setNextGuard(String stepId, NextGuard? guard) {
    if (guard == null)
      _nextGuards.remove(stepId);
    else
      _nextGuards[stepId] = guard;
  }

  void start() => onStart?.call();

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

  Future<void> nextWithGuard() async {
    final guard = _nextGuards[currentId];
    if (guard != null) {
      final ok = await guard();
      if (!ok) return;
    }
    next();
  }
}
