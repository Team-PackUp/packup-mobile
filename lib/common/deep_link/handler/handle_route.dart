import 'package:packup/Common/util.dart';
import 'package:packup/main.dart';

// 채팅 라우팅
void handleChatMessageRoute(Uri uri) async {
  print(uri.pathSegments);

  final userSeq = await decodeTokenInfo();

  final segments = uri.pathSegments;

  if (segments.length != 3) return;

  final prefix = segments[0];
  final roomSeq = int.tryParse(segments[1]);
  final title = uri.pathSegments[2];

  if (roomSeq == null) return;
  String fullUrl = '/$prefix/$roomSeq/$title/$userSeq';

  globalRouter.go(fullUrl);
}

