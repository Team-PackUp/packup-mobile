import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:packup/model/reply/reply_model.dart';

class ReplyForm extends StatefulWidget {
  final ReplyModel? initialReply;
  final Future<void> Function(String content) onSubmit;

  const ReplyForm({
    super.key,
    this.initialReply,
    required this.onSubmit,
  });

  @override
  State<ReplyForm> createState() => _ReplyFormState();
}

class _ReplyFormState extends State<ReplyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.initialReply?.content ?? '');
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(_contentController.text.trim());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: 'location.login',
              border: const OutlineInputBorder(),
            ),
            minLines: 5,
            maxLines: 10,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'location.contentRequired';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _handleSubmit,
            icon: _isSubmitting
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.send),
            label: Text(widget.initialReply == null ? 'location.register' : 'location.update'),
          ),
        ],
      ),
    );
  }
}
