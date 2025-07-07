import '../../../http/dio_service.dart';
import '../../../model/common/result_model.dart';
import '../../../model/profile/alert_center/alert_center_model.dart';

class AlertCenterService {

  static final AlertCenterService _instance = AlertCenterService._internal();

  // 객체 생성 방지
  AlertCenterService._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory AlertCenterService() {
    return _instance;
  }

  Future<ResultModel> getAlertList(int page) async {
    final data = {'page' : page};
    return await DioService().getRequest('/alert/list', data);
  }

  Future<ResultModel> markRead(AlertCenterModel n) async {
    return await DioService().putRequest('/alert/read/${n.seq}');
  }
}