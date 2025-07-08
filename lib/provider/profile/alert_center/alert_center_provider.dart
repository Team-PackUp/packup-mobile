
import 'package:packup/provider/common/loading_provider.dart';

import '../../../model/common/page_model.dart';
import '../../../model/profile/alert_center/alert_center_model.dart';
import '../../../service/common/loading_service.dart';
import '../../../service/profile/alert_center/alert_center_service.dart';

class AlertCenterProvider extends LoadingProvider {
  final alertService = AlertCenterService();

  late List<AlertCenterModel> _alertList;

  AlertCenterProvider() {
    _alertList = [];
  }

  int _totalPage = 0;
  int _curPage = 0;

  List<AlertCenterModel> get alertList => _alertList;
  int get totalPage => _totalPage;
  int get curPage => _curPage;

  Future<void> getAlertList() async {
    if(_totalPage < _curPage) return;

    await LoadingService.run(() async {
      final response = await alertService.getAlertList(_curPage);
      PageModel pageModel = PageModel.fromJson(response.response);

      List<AlertCenterModel> list = pageModel.objectList
          .map((data) => AlertCenterModel.fromJson(data))
          .toList();

      _alertList.addAll(list);
      _totalPage = pageModel.totalPage;

      _curPage++;

      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> markRead(AlertCenterModel alertCenterModel) async {
    await LoadingService.run(() async {
      await alertService.markRead(alertCenterModel);

      notifyListeners();
    });
  }
}
