import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:packup/provider/search_bar/custom_search_bar_provider.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "검색어를 입력해주세요",
              ),
              onChanged: (value) {
                context.read<SearchBarProvider>().setSearchText(value);
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              context.read<SearchBarProvider>().fetchResults();
            },
          ),
        ],
      ),
    );
  }
}
