import '../../provider/common/loading_provider.dart';

class LoadingService {
  static late LoadingProvider notifier;

  static final LoadingService _instance = LoadingService._internal();
  factory LoadingService() => _instance;
  LoadingService._internal();

  static Future<T> run<T>(Future<T> Function() cb) async {
    return notifier.handleLoading(cb);
  }
}
