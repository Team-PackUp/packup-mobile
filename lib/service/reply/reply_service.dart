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

  Future<ResultModel> getReply(int replySeq) async {
    return await DioService().getRequest('/reply/view/$replySeq');
  }

  Future<ResultModel> saveReply({
    required int targetSeq,
    required String targetType,
    required String content,
  }) async {
    final data = {
      'target_seq'  : targetSeq,
      'target_type' : targetType,
      'content'     : content,
    };
    return DioService().postRequest('/reply/save', data);
  }

  Future<ResultModel> updateReply({
    required int seq,
    required String content,
  }) async {
    final data = {
      'seq'     : seq,
      'content' : content,
    };
    return DioService().putRequest('/reply/update', data);
  }

  Future<ResultModel> deleteReply(int seq) async {
    final data = { 'seq': seq };
    return DioService().deleteRequest('/reply/delete', data);
  }
}