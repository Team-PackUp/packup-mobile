
import 'package:packup/provider/common/loading_provider.dart';

import '../../../model/common/page_model.dart';
import '../../../model/profile/alert_center/alert_center_model.dart';
import '../../../service/common/loading_service.dart';
import '../../service/alert_center/alert_center_service.dart';

class AlertCenterProvider extends LoadingProvider {
  final alertService = AlertCenterService();

  late List<AlertCenterModel> _alertList;
  late int _alertCount;

  AlertCenterProvider() {
    _alertList = [];
    _alertCount = 0;
  }

  initProvider() async {
    await getAlertCount();
  }

  List<AlertCenterModel> get alertList => _alertList;
  int get alertCount => _alertCount;

  Future<void> getAlertCount() async {
    await LoadingService.run(() async {
      final response = await alertService.getAlertCount();
      _alertCount  = response.response;
      notifyListeners();
    });
  }

  Future<void> getAlertList({bool reset = false}) async {
    if (reset) {
      _alertList.clear();
      _alertCount = 0;
    }

    await LoadingService.run(() async {
      final response = await alertService.getAlertList();
      final page = PageModel<AlertCenterModel>.fromJson(response.response,
            (e) => AlertCenterModel.fromJson(e),
      );

      _alertList.addAll(page.objectList);

      notifyListeners();
    });

    getAlertCount();
  }
}
