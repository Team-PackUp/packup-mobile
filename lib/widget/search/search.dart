import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;

  const CustomSearch({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenW * 0.03,
        vertical: screenH * 0.01,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: kToolbarHeight - screenH * 0.01,
          padding: EdgeInsets.symmetric(horizontal: screenW * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenW * 0.05),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: screenW * 0.02),
              Expanded(
                child: Text(
                  '같이 여름휴가 갈 사람 구함@@',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
