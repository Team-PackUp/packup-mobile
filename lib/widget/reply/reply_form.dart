import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/custom_point_input.dart';

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
  int _point = 0;

  @override
  void initState() {
    super.initState();
    _replyProvider = widget.replyProvider;

    _contentController = TextEditingController(text: '');

    _initData();
    _replyProvider.addListener(_initData);
  }

  void _initData() {
    final model = _replyProvider.replyModel;
    if (model == null) return;

    _contentController.text = model.content ?? '';
    _point = model.point ?? 0;

    setState(() {});
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _replyProvider.seq != null;

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
              CustomPointInput(
                onPointChanged: handlePoint,
                mode: PointMode.edit,
                initialPoint: _point,
              ),
              // 전송
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _upsertReply,
                  icon: _isSubmitting
                      ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                    height: MediaQuery.of(context).size.height * 0.02,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.send),
                  label: Text(isEdit ? 'update' : 'save'),
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

  void handlePoint(int? point) {
    setState(() {
      _point = point!;
    });
  }


  Future<void> _upsertReply() async {
    if(_formKey.currentState!.validate()) {
      await _replyProvider.upsertReply(
          _contentController.text, _point,
          AppLocalizations.of(context)!.notice,
          AppLocalizations.of(context)!.advertise
      );

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
