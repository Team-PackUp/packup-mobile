import 'package:flutter/material.dart';

class ReplySubmitBar extends StatelessWidget {
  final bool isEdit;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onDelete;

  const ReplySubmitBar({
    super.key,
    required this.isEdit,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: isSubmitting
                ? const SizedBox(
              height: 20, width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(isEdit ? '리뷰 수정' : '리뷰 제출'),
          ),
        ),
        if (isEdit) ...[
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(52, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: isSubmitting ? onSubmit : onDelete,
            icon: const Icon(Icons.delete_forever),
            label: const Text('삭제'),
          ),
        ],
      ],
    );
  }
}
