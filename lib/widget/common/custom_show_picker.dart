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
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Container(
      height: screenH * 0.5,
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
            height: screenH * 0.005,
            width: screenW * 0.3,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.03,
                vertical: screenH * 0.001
            ),
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
              itemExtent: screenH * 0.05,
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

