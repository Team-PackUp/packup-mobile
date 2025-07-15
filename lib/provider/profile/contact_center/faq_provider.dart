import 'package:packup/model/common/page_model.dart';
import 'package:packup/provider/common/loading_provider.dart';
import 'package:packup/service/common/loading_service.dart';

import '../../../model/profile/contact_center/faq_category_model.dart';
import '../../../model/profile/contact_center/faq_model.dart';
import '../../../service/profile/contact_center/faq_service.dart';

class FaqProvider extends LoadingProvider {

  final service = FaqService();

  List<FaqModel> _faqModel = [];
  List<FaqCategoryModel> _faqCategory = [];

  List<FaqModel> get faqModel => _faqModel;
  List<FaqCategoryModel> get faqCategory => _faqCategory;

  getFaqCategory() async {
    await LoadingService.run(() async {
      final response = await service.getFaqCategory();
      List<FaqCategoryModel> list = (response.response as List)
          .map((e) => FaqCategoryModel.fromJson(e))
          .toList();

      _faqCategory.addAll(list);

      notifyListeners();
    });
  }

  // FAQ 리스트
  getFaqList() async {

    await LoadingService.run(() async {
      final response = await service.getFaqList();
      List<FaqModel> list = (response.response as List).map((e) => FaqModel.fromJson(e)).toList();

      print(list.length);
      _faqModel.addAll(list);

      notifyListeners();
    });
  }

  getFaqByCategory(String category) async {

    await LoadingService.run(() async {
      final response = await service.getFaqByCategory(category);
      final list = FaqModel.fromJson(response.response);

      print(list);

      notifyListeners();
    });
  }
}