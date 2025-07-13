import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_empty_list.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    print('검색어: $text');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _controller,
          decoration: const InputDecoration(
            hintText: '검색어를 입력해주세요',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomEmptyList(
        message: '검색 결과가 존재 하지 않습니다요',
        icon: Icons.flight,
      ),
    );
  }
}
