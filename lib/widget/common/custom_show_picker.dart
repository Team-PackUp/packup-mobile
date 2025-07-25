import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPickerBottomSheet extends StatelessWidget {
  final int selectedIndex;
  final List<String> options;
  final void Function(int selected) onSelected;
  final String title;

  const CustomPickerBottomSheet({
    super.key,
    required this.selectedIndex,
    required this.options,
    required this.onSelected,
    this.title = '선택',
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Container(
      height: h * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('완료', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: selectedIndex),
              itemExtent: 40,
              magnification: 1.1,
              useMagnifier: true,
              backgroundColor: Colors.white,
              onSelectedItemChanged: onSelected,
              children: options.map((lang) => Center(child: Text(lang))).toList(),
            ),
          ),
        ],
      ),
    );
  }

}

void showCustomPicker(BuildContext context, {
  required int selectedIndex,
  required List<String> options,
  required void Function(int) onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => CustomPickerBottomSheet(
      selectedIndex: selectedIndex,
      options: options,
      onSelected: onSelected,
    ),
  );
}

