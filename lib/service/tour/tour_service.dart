import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';

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

  Future<ResultModel> getMyListings(int page) async {
    final data = {'page': page};
    return await DioService().getRequest('/tour/me/listings', data);
  }

  //  Future<void> createListing(TourListingCreateRequest req) async {
  //   await DioService().postRequest('/guide/tours', data: req.toJson());
  // }
}
