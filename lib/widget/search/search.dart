import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;

  const CustomSearch({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: kToolbarHeight - 8,          // 앱바 높이와 비슷하게만
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
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
