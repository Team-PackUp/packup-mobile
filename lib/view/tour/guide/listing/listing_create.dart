import 'package:flutter/material.dart';
import 'package:packup/widget/common/custom_appbar.dart';

class ListingCreatePage extends StatelessWidget {
  const ListingCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(title: '리스팅 등록'),
      body: Center(child: Text('ListingCreatePage (초기 스텁)')),
    );
  }
}
