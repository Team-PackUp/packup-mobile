
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class QuillViewService {
  static final QuillViewService _instance = QuillViewService._internal();

  factory QuillViewService() => _instance;

  QuillViewService._internal();

  QuillController? _quillController;
  QuillController? get quillController => _quillController;

  Future<void> empty() async {
    _quillController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void setQuillDelta(String jsonContent) {
    final contentJson = jsonDecode(jsonContent);
    final delta = Delta.fromJson(contentJson['ops']);

    _quillController = QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

}