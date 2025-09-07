import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/tour/tour_create_request.dart';
import 'package:packup/model/tour/tour_session_create_request.dart';
import 'package:packup/model/tour/tour_session_model.dart';

class TourService {
  Future<ResultModel> getTourList({
    required int page,
    required int size,
  }) async {
    final query = {'page': page, 'size': size};

    return await DioService().getRequest('/tour/user', query);
  }

  Future<ResultModel> getTourListByRegion({
    required String regionCode,
    required int page,
    required int size,
  }) async {
    print(regionCode);
    final query = {'page': page, 'size': size};

    return await DioService().getRequest('/tour/$regionCode', query);
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

  Future<List<TourSessionModel>> fetchSessions(int tourSeq) async {
    final ResultModel res = await DioService().getRequest(
      '/tour/$tourSeq/sessions',
    );

    final dynamic payload = res.response;

    final List<dynamic> list = switch (payload) {
      List<dynamic> l => l,
      Map<String, dynamic> m when m['content'] is List => m['content'] as List,
      _ => <dynamic>[],
    };

    return list
        .map((e) => TourSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ResultModel> createSession({
    required int tourSeq,
    required TourSessionCreateRequest req,
  }) async {
    final url = '/tour/guide/$tourSeq/sessions';
    return await DioService().postRequest(url, req.toJson());
  }

  Future<void> deleteSession(int sessionSeq) async {
    await DioService().deleteRequest('/tour/guide/sessions/$sessionSeq');
  }

  Future<void> updateListing(String id, TourCreateRequest req) async {
    await DioService().putRequest('/tour/listing/$id', req.toJson());
  }

  Future<Map<String, dynamic>> fetchListingDetail(String id) async {
    final ResultModel res = await DioService().getRequest('/tour/listing/$id');
    final dynamic payload = res.response;
    if (payload is Map<String, dynamic>) return payload;
    if (payload is List &&
        payload.isNotEmpty &&
        payload.first is Map<String, dynamic>) {
      return payload.first as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }
}
