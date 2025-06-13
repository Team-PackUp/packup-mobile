import 'package:packup/Common/util.dart';
import 'package:packup/main.dart';

class DeepLinkRouter {
  static Function(int index, {Map<String, dynamic>? payload})? _navigator;

  static void registerNavigator(
      Function(int index, {Map<String, dynamic>? payload}) navigator) {
    _navigator = navigator;
  }

  static void navigateToTab(int index, {Map<String, dynamic>? payload}) {
    _navigator?.call(index, payload: payload);
  }
}
