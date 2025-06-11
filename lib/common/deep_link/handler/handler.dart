import 'package:packup/Common/util.dart';
import 'package:packup/common/deep_link/handler/route.dart';

// 딥링크 경로 찾아서 실행
void handleDeepLink(String deepLink) {
  final uri = Uri.parse(deepLink);
  final path = uri.path;

  for (final entry in deepLinkRoutes) {
    if (entry.key.hasMatch(path)) {
      entry.value(uri);
      return;
    }
  }

  logger("딥링크 에러 $path", "ERROR");
}
