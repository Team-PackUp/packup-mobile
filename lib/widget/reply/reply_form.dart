import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:packup/provider/reply/reply_provider.dart';

class ReplyForm extends StatefulWidget {
  final ReplyProvider replyProvider;

  const ReplyForm({
    super.key,
    required this.replyProvider,
  });

  @override
  State<ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyForm> {

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;
  late ReplyProvider _replyProvider;

  final bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _replyProvider = widget.replyProvider;

    if(_replyProvider.replyModel?.seq != null) {
      _contentController = TextEditingController(text: _replyProvider.replyModel?.content);
    } else {
      _contentController = TextEditingController(text: '');
    }

    _syncWithProvider();
    _replyProvider.addListener(_syncWithProvider);
  }

  void _syncWithProvider() {
    final text = _replyProvider.replyModel?.content ?? '';
    if (_contentController.text != text) _contentController.text = text;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _replyProvider.seq != null;   // ← 수정 모드 여부

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _contentController,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: 'reply...',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'reply required..' : null,
          ),
          const SizedBox(height: 12),

          /// 전송 & 삭제(수정모드) 버튼
          Row(
            children: [
              // 전송
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _upsertReply,
                  icon: _isSubmitting
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.send),
                  label: Text(isEdit ? 'update reply' : 'new reply'),
                ),
              ),

              // 삭제 (수정 모드일 때만)
              if (isEdit) ...[
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: _isSubmitting ? null : _deleteReply,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('delete'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }


  Future<void> _upsertReply() async {
    if(_formKey.currentState!.validate()) {
      await _replyProvider.upsertReply(_contentController.text);

      if (mounted) Navigator.pop(context, true);
    }
  }

  Future<void> _deleteReply() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Reply'),
        content: const Text('정말 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true),  child: const Text('삭제')),
        ],
      ),
    );

    if (confirm != true) return;

    await _replyProvider.deleteReply();
    if (mounted) Navigator.pop(context, true);
  }

}
