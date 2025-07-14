import 'package:flutter/material.dart';
import 'package:packup/provider/search/search_provider.dart';
import 'package:packup/widget/common/custom_empty_list.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
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
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
