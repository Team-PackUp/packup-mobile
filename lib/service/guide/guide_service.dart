import 'package:image_picker/image_picker.dart';
import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';
import 'package:packup/model/guide/guide_intro_model.dart';

class GuideService {
  static final GuideService _instance = GuideService._internal();
  final DioService _dio = DioService();

  GuideService._internal();
  factory GuideService() => _instance;

  Future<ResultModel> submitApplication({
    required String selfIntro,
    required XFile idImage,
  }) async {
    return await _dio.multipartRequestWithFields(
      '/guide/application',
      idImage,
      fileFieldName: 'idImage',
      extraFields: {'selfIntro': selfIntro},
    );
  }

  Future<ResultModel> fetchMyIntro() async {
    return await _dio.getRequest('/guide/intro/me');
  }

  Future<ResultModel> upsertIntro(GuideIntroModel model) async {
    return await _dio.putRequest('/guide/intro/me', model.toJson());
  }

  Future<ResultModel> getGuideList({required int page, required size}) async {
    final data = {'size' : size, 'page' : page};
    return await _dio.getRequest('/guide/list', data);
  }
}
