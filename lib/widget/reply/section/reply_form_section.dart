import 'dart:io';
import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:packup/provider/reply/reply_provider.dart';
import 'package:packup/widget/common/util_widget.dart';
import 'package:packup/widget/reply/reply_card.dart';
import 'package:packup/widget/reply/reply_content_field.dart';
import 'package:packup/widget/reply/reply_intro_card.dart';
import 'package:packup/widget/reply/reply_photo_grid.dart';
import 'package:packup/widget/reply/reply_section_title.dart';
import 'package:packup/widget/reply/reply_star_rating.dart';
import 'package:packup/widget/reply/reply_submit_bar.dart';

class ReplyFormSection extends StatefulWidget {
  final ReplyProvider replyProvider;

  const ReplyFormSection({
    super.key,
    required this.replyProvider,
  });

  @override
  State<ReplyFormSection> createState() => _ReplyFormSectionState();
}

class _ReplyFormSectionState extends State<ReplyFormSection> {
  static const int _minChars = 10;
  static const int _maxChars = 500;
  static const int _maxPhotos = 5;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contentController;
  late ReplyProvider _replyProvider;

  bool _isSubmitting = false;
  int _point = 0;

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _photos = [];

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
    _replyProvider.removeListener(_initData);
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final canAdd = _maxPhotos - _photos.length;
    if (canAdd <= 0) return;

    final files = await _picker.pickMultiImage();
    if (files.isEmpty) return;

    setState(() {
      _photos.addAll(files.take(canAdd));
    });
  }

  bool get _canSubmit {
    final len = _contentController.text.trim().characters.length;
    return _point > 0 && len >= _minChars && len <= _maxChars && !_isSubmitting;
  }

  Future<void> _upsertReply() async {
    if (!_canSubmit) {
      if (_point <= 0) {
        CustomSnackBar.showError(context, '평점을 입력해주세요');
      } else {
        CustomSnackBar.showError(context, '리뷰는 최소 $_minChars자 이상 작성해주세요.');
      }
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _replyProvider.upsertReply(
        _contentController.text.trim(),
        _point,
        'notice',
        'advertise',
      );
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deleteReply() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('리뷰 삭제'),
        content: const Text('정말 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isSubmitting = true);
    try {
      await _replyProvider.deleteReply();
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _replyProvider.seq != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 터치 시 키보드 내림,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ReplyCard(child: ReplyIntroCard()),

              const ReplySectionTitle('평점 주기'),
              ReplyCard(
                child: ReplyStarRating(
                  value: _point,
                  onChanged: (v) => setState(() => _point = v),
                ),
              ),

              const ReplySectionTitle('리뷰 작성'),
              ReplyCard(
                child: ReplyContentField(
                  controller: _contentController,
                  maxChars: _maxChars,
                ),
              ),

              const ReplySectionTitle('사진 추가 (선택 사항 최대 5장)'),
              ReplyCard(
                child: ReplyPhotoGrid(
                  photos: _photos,
                  maxPhotos: _maxPhotos,
                  onAddPressed: _pickPhotos,
                  onRemoveAt: (i) => setState(() => _photos.removeAt(i)),
                ),
              ),

              const SizedBox(height: 24),

              ReplySubmitBar(
                enabled: _canSubmit,
                isEdit: isEdit,
                isSubmitting: _isSubmitting,
                onSubmit: _upsertReply,
                onDelete: _deleteReply,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
