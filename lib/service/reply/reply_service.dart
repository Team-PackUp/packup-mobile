import '../../http/dio_service.dart';
import '../../model/common/result_model.dart';

class ReplyService {

  Future<ResultModel> getReplyList(int page) async {
    final data = {'page' : page};
    return await DioService().getRequest('/reply/list', data);
  }
}