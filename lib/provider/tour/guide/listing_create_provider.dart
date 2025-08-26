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

  int _index = 0;
  int get index => _index;
  int get total => steps.length;
  ListingStepConfig get current => steps[_index];

  void start() {
    onStart?.call();
  }
}
