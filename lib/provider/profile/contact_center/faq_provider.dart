import 'package:flutter/cupertino.dart';

import '../../../model/profile/contact_center/faq_category_model.dart';
import '../../../model/profile/contact_center/faq_model.dart';
import '../../../service/common/loading_service.dart';
import '../../../service/profile/contact_center/faq_service.dart';
import '../../common/loading_provider.dart';

class FaqProvider extends ChangeNotifier {
  final _service = FaqService();

  /// 전체 목록
  final List<FaqModel> _allFaqs = [];

  /// 화면에 노출할 목록
  List<FaqModel> _faqs = [];

  /// 카테고리 목록
  final List<FaqCategoryModel> _category = [];

  List<FaqModel> get faqList        => _faqs;
  List<FaqCategoryModel> get category => _category;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getFaqCategory() async {
    _isLoading = true;
    await LoadingService.run(() async {
      final res = await _service.getFaqCategory();
      final list = (res.response as List)
          .map((e) => FaqCategoryModel.fromJson(e))
          .toList();

      _category
        ..clear()
        ..addAll(list);

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> getFaqList() async {
    _isLoading = true;

    await LoadingService.run(() async {
      final res = await _service.getFaqList();
      final list = (res.response as List)
          .map((e) => FaqModel.fromJson(e))
          .toList();

      _allFaqs
        ..clear()
        ..addAll(list);

      _faqs = List<FaqModel>.from(_allFaqs);

      _isLoading = false;
      notifyListeners();
    });
  }

  void filterByCategory(FaqCategoryModel category) {
    _isLoading = true;

    if (category.codeName == '전체') {
      _faqs = List<FaqModel>.from(_allFaqs);
    } else {
      _faqs = _allFaqs
          .where((e) => e.faqType == category.codeId)
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }
}
