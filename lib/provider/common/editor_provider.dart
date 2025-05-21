import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class EditorProvider extends ChangeNotifier {
  late QuillController _quillController;
  QuillController get quillController => _quillController;

  String _content = '';
  String get content => _content;

  EditorProvider(String data) {
    _content = data;

    if (_content.trim().isNotEmpty) {
      setQuillDelta(_content);
    } else {
      empty();
    }

    _quillController.readOnly = true;

    notifyListeners();
  }

  void empty() {
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
