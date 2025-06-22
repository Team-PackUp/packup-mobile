import 'package:packup/model/reply/reply_model.dart';

import '../../http/dio_service.dart';
import '../../model/common/result_model.dart';

class ReplyService {

  Future<ResultModel> getReplyList(int page, {
    required ReplyModel replyModel,
  }) async {
    final data = {
      'page' : page,
      ...replyModel.toMap()
    };

    return await DioService().getRequest('/reply/list', data);
  }

  Future<ResultModel> getReply({
    required int seq
  }) async {
    return await DioService().getRequest('/reply/view/$seq');
  }

  Future<ResultModel> saveReply({
    required ReplyModel replyModel,
  }) async {

    return DioService().postRequest('/reply/save', replyModel.toMap());
  }

  Future<ResultModel> updateReply({
    required int seq,
    required ReplyModel replyModel,
  }) async {

    return DioService().putRequest('/reply/update/$seq', replyModel.toMap());
  }

  Future<ResultModel> deleteReply({
    required int seq,
  }) async {
    return DioService().deleteRequest('/reply/delete/$seq');
  }
}