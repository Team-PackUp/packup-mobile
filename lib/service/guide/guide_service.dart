import 'package:image_picker/image_picker.dart';
import 'package:packup/http/dio_service.dart';
import 'package:packup/model/common/result_model.dart';

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
}
