import 'package:flutter/foundation.dart';

enum SearchType {all, ai}

class SearchProvider with ChangeNotifier {

  late String _searchText;
  late SearchType _searchType;

  SearchProvider(SearchType searchType) {
    _searchType = searchType;
  }

  
  // 대상 상품 리스트 init 조회
  initContent() {
    print("$_searchType => 검색 대상 리스트 조회를 시작합니다.");
  }

  Future<void> filterContent(String searchText) async {
    print('검색어: $searchText');
    _searchText = searchText;
  }
}
