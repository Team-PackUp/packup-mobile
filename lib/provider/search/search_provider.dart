import 'package:flutter/foundation.dart';

class SearchProvider with ChangeNotifier {

  
  // 대상 상품 리스트 init 조회
  initContent() {
    print("검색 대상 리스트 조회를 시작합니다.");
  }
  

  Future<void> searchContent(String searchText) async {
    print('검색어: $searchText');
  }
}
