import '../../provider/common/loading_provider.dart';

class LoadingService {
  static late LoadingProvider notifier;

  static Future<T> run<T>(Future<T> Function() cb) async {
    return notifier.handleLoading(cb);
  }
}
