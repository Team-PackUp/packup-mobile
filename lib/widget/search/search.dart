import 'package:flutter/material.dart';

enum SearchMode {
  fake,    // 탭해서 전체 검색 페이지 이동
  input,   // 실제 검색 인풋 필드
}

class CustomSearch extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final String hint;
  final SearchMode mode;
  final ValueChanged<String>? onChanged;

  const CustomSearch({
    super.key,
    this.onTap,
    this.hint = '같이 여름휴가 갈 사람 구함@@',
    this.mode = SearchMode.fake,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    final commonDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(screenW * 0.05),
      border: Border.all(color: Colors.grey.shade300),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenW * 0.03,
        vertical: screenH * 0.01,
      ),
      child: mode == SearchMode.fake
          ? InkWell(
        onTap: onTap,
        child: Container(
          height: kToolbarHeight - screenH * 0.01,
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.03),
          decoration: commonDecoration,
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: screenW * 0.02),
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      )
          : Container(
        height: kToolbarHeight - screenH * 0.01,
        padding: EdgeInsets.symmetric(horizontal: screenW * 0.03),
        decoration: commonDecoration,
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: screenW * 0.02),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
