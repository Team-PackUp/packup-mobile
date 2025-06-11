import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';

class TourService {

  // Future<ResultModel> getTourList() async {
  //   return await DioService().getRequest('/tour');
  // }

  Future<ResultModel> getTourList({required int page, required int size}) async {
    final query = {
      'page': page,
      'size': size,
    };

    return await DioService().getRequest('/tour', query);
  }

  // Future<ResultModel> getNoticeView(int noticeSeq) async {
  //   return await DioService().getRequest('/notice/view/$noticeSeq');
  // }
}