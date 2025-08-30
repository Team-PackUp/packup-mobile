import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/tour/tour_create_request.dart';

class TourService {
  Future<ResultModel> getTourList({
    required int page,
    required int size,
  }) async {
    final query = {'page': page, 'size': size};

    return await DioService().getRequest('/tour/user', query);
  }

  Future<void> updateTour(int seq, Map<String, dynamic> body) async {
    final url = '/tour/guide/$seq';
    await DioService().putRequest(url, body);
  }

  Future<void> createTour(Map<String, dynamic> body) async {
    final url = '/tour/guide';
    await DioService().postRequest(url, body);
  }

  Future<ResultModel> getMyListings({required int page, int size = 20}) async {
    final params = {'page': page, 'size': size};

    return await DioService().getRequest('/tour/me/listings', params);
  }

  Future<void> createTourReq(TourCreateRequest req) async {
    await DioService().postRequest('/tour/listing', req.toJson());
  }
}
