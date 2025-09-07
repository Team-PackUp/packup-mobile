import 'package:flutter/foundation.dart';
import 'package:packup/common/util.dart';
import 'package:packup/provider/guide/guide_provider.dart';
import 'package:packup/provider/tour/tour_provider.dart';

import '../../service/common/loading_service.dart';

class HomeProvider extends ChangeNotifier {
  TourProvider? _tours;
  GuideProvider? _guides;

  void bind({
    required TourProvider tours,
    required GuideProvider guides,
  }) {
    _tours = tours;
    _guides = guides;
  }

  bool _initialized = false;
  bool _isLoading = false;
  late String _regionCode;

  String get regionCode => _regionCode;

  Future<void> initHome() async {
    if (_initialized) return;
    _initialized = true;

    _setLoading(true);
    try {
      _regionCode = await getDefaultRegion();

      await LoadingService.run(() async {
        await Future.wait([
          _tours!.getTourListNoProgress(regionCode: _regionCode),
          _guides!.getGuideList(5),
        ]);
      });

    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> changeRegion(String code) async {
    if (code == _regionCode) return;
    _regionCode = code;
    notifyListeners();

    await saveDefaultRegion(code);

    _setLoading(true);
    try {
      await _tours!.getTourList(refresh: true, regionCode: code);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    notifyListeners();
  }
}
