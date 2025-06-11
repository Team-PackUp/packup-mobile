import 'handle_route.dart';

typedef DeepLinkHandler = void Function(Uri uri);

// 딥링크 URL 리스트
final List<MapEntry<RegExp, DeepLinkHandler>> deepLinkRoutes = [
  MapEntry(RegExp(r'^/chat_message/\d+/[^/]+$'), handleChatMessageRoute),
];
