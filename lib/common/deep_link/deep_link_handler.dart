import 'package:packup/Common/util.dart';

import 'handle_router.dart';

class DeepLinkHandler {

  static final DeepLinkHandler _instance = DeepLinkHandler._internal();

  DeepLinkHandler._internal();

  factory DeepLinkHandler() => _instance;

  void handle(Map<String, dynamic> data) {
    final type = data['deepLinkType'];
    final parameters = data['parameter'];

    switch (type) {
      case 'CHAT':
        _handleChatDeepLink(parameters);
        break;
    }
  }


  void _handleChatDeepLink(dynamic parameters) {
    if (parameters.isEmpty) return;

    final chatRoomId = parameters['chatRoomSeq'];

    DeepLinkRouter.navigateToTab(3, payload: {
      'chatRoomId': chatRoomId,
    });
  }
}

