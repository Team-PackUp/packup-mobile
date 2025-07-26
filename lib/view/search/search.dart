import 'package:flutter/material.dart';
import 'package:packup/provider/search/search_provider.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  final SearchType searchType;

  const Search({super.key, required this.searchType});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(searchType),
      child: SearchContent(),
    );
  }
}

class SearchContent extends StatefulWidget {

  const SearchContent({super.key});

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  late final SearchProvider provider;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  bool _showKeyboardCloseButton = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _showKeyboardCloseButton = _focusNode.hasFocus;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = context.read<SearchProvider>()..initContent();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String searchText) {
    provider.filterContent(searchText);
  }

  @override
  Widget build(BuildContext context) {

    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    final viewInsets = MediaQuery.of(context).viewInsets;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(screenW * 0.03),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenW * 0.01
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(screenW * 0.05),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            focusNode: _focusNode,
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: '검색어를 입력해주세요',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                            onChanged: _onSearchChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenH * 0.2),
              Padding(
                padding: EdgeInsets.only(bottom: viewInsets.bottom),
                child: CustomEmptyList(
                  message: '검색 결과가 존재 하지 않습니다요',
                  icon: Icons.flight,
                ),
              ),
            ],
          ),


          if (_showKeyboardCloseButton)
            Positioned(
              bottom: viewInsets.bottom,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(
                    horizontal: screenW * 0.08,
                    vertical: screenH * 0.015
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus(); // 키보드 내림
                        setState(() {
                          _showKeyboardCloseButton = false; // 버튼 즉시 숨김
                        });
                      },
                      child: const Text(
                        '닫기',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
